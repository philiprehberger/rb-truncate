# frozen_string_literal: true

require 'strscan'
require_relative 'truncate/version'

module Philiprehberger
  module Truncate
    DEFAULT_OMISSION = '...'

    OPENING_TAG = /<(\w+)(?:\s[^>]*)?>/
    CLOSING_TAG = %r{</(\w+)>}
    SELF_CLOSING_TAG = %r{<\w+(?:\s[^>]*)?\s*/>}
    TAG_PATTERN = %r{</?[^>]+>}
    SENTENCE_BOUNDARY = /(?<=[.!?])\s+/

    class << self
      def words(text, count, omission: DEFAULT_OMISSION)
        return '' if text.empty?

        parts = text.split(/\s+/)
        return text if parts.length <= count

        parts.first(count).join(' ') + omission
      end

      def chars(text, count, omission: DEFAULT_OMISSION)
        return '' if text.empty?
        return text if text.length <= count

        limit = count - omission.length
        return omission[0, count] if limit <= 0

        truncated = text[0, limit]

        if limit < text.length && text[limit] =~ /\S/ && truncated.include?(' ')
          boundary = truncated.rindex(/\s/)
          truncated = truncated[0, boundary] if boundary
        end

        truncated.rstrip + omission
      end

      def sentences(text, count, omission: DEFAULT_OMISSION)
        return '' if text.empty?

        parts = text.split(SENTENCE_BOUNDARY)
        return text if parts.length <= count

        parts.first(count).join(' ') + omission
      end

      def html(html, char_count, omission: DEFAULT_OMISSION)
        return '' if html.empty?

        open_tags = []
        visible_chars = 0
        result = +''
        scanner = StringScanner.new(html)

        while !scanner.eos? && visible_chars < char_count
          if scanner.scan(SELF_CLOSING_TAG)
            result << scanner.matched
          elsif scanner.scan(CLOSING_TAG)
            tag_name = scanner[1]
            open_tags.delete_at(open_tags.rindex(tag_name)) if open_tags.include?(tag_name)
            result << scanner.matched
          elsif scanner.scan(OPENING_TAG)
            open_tags.push(scanner[1])
            result << scanner.matched
          elsif scanner.scan(TAG_PATTERN)
            result << scanner.matched
          else
            char = scanner.getch
            visible_chars += 1
            result << char
          end
        end

        if scanner.eos?
          html
        else
          result << omission
          open_tags.reverse_each { |tag| result << "</#{tag}>" }
          result
        end
      end
    end
  end
end
