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
      def batch(strings, length, omission: DEFAULT_OMISSION, position: :end)
        strings.map { |s| chars(s, length, omission: omission, position: position) }
      end

      def words(text, count, omission: DEFAULT_OMISSION, position: :end)
        return '' if text.empty?

        parts = text.split(/\s+/)
        return text if parts.length <= count

        case position
        when :start
          omission + parts.last(count).join(' ')
        when :middle
          half = count / 2
          tail = count - half
          parts.first(half).join(' ') + omission + parts.last(tail).join(' ')
        else
          parts.first(count).join(' ') + omission
        end
      end

      def chars(text, count, omission: DEFAULT_OMISSION, position: :end)
        return '' if text.empty?
        return text if text.length <= count

        case position
        when :start
          chars_start(text, count, omission)
        when :middle
          chars_middle(text, count, omission)
        else
          chars_end(text, count, omission)
        end
      end

      def sentences(text, count, omission: DEFAULT_OMISSION, position: :end)
        return '' if text.empty?

        parts = text.split(SENTENCE_BOUNDARY)
        return text if parts.length <= count

        case position
        when :start
          omission + parts.last(count).join(' ')
        when :middle
          half = count / 2
          tail = count - half
          parts.first(half).join(' ') + omission + parts.last(tail).join(' ')
        else
          parts.first(count).join(' ') + omission
        end
      end

      # Truncate by byte length, preserving UTF-8 boundaries so no partial
      # multi-byte codepoint is emitted. Useful for database column limits
      # (`VARCHAR(255)` is bytes under MySQL `utf8mb4`), HTTP header budgets,
      # and message-size caps. The omission string's byte length is included
      # in the budget.
      #
      # @param text [String] the input string
      # @param byte_count [Integer] maximum byte length of the result
      # @param omission [String] suffix appended when truncated (default `'...'`)
      # @param position [Symbol] `:end`, `:start`, or `:middle`
      # @return [String] truncated string, at or under `byte_count` bytes
      def bytes(text, byte_count, omission: DEFAULT_OMISSION, position: :end)
        return '' if text.empty?

        bytes_in = text.bytesize
        return text if bytes_in <= byte_count

        omission_bytes = omission.bytesize
        return safe_byte_slice(omission, byte_count) if byte_count <= omission_bytes

        case position
        when :start
          bytes_start(text, byte_count, omission, omission_bytes)
        when :middle
          bytes_middle(text, byte_count, omission, omission_bytes)
        else
          bytes_end(text, byte_count, omission, omission_bytes)
        end
      end

      def lines(text, count, omission: DEFAULT_OMISSION)
        return '' if text.empty?

        all_lines = text.split("\n", -1)
        return text if all_lines.length <= count

        all_lines.first(count).join("\n") + omission
      end

      def strip_html(html, length, omission: DEFAULT_OMISSION)
        return '' if html.empty?

        plain = html.gsub(/<[^>]+>/, ' ')
        plain = plain.gsub('&amp;', '&')
                     .gsub('&lt;', '<')
                     .gsub('&gt;', '>')
                     .gsub('&quot;', '"')
                     .gsub('&apos;', "'")
                     .gsub(/&#x([0-9a-fA-F]+);/) { ::Regexp.last_match(1).to_i(16).chr(Encoding::UTF_8) }
                     .gsub(/&#([0-9]+);/) { ::Regexp.last_match(1).to_i.chr(Encoding::UTF_8) }
        plain = plain.gsub(/\s+/, ' ').strip

        chars(plain, length, omission: omission)
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

      private

      def chars_end(text, count, omission)
        limit = count - omission.length
        return omission[0, count] if limit <= 0

        truncated = text[0, limit]

        if limit < text.length && text[limit] =~ /\S/ && truncated.include?(' ')
          boundary = truncated.rindex(/\s/)
          truncated = truncated[0, boundary] if boundary
        end

        truncated.rstrip + omission
      end

      def chars_start(text, count, omission)
        limit = count - omission.length
        return omission[0, count] if limit <= 0

        omission + text[text.length - limit, limit].lstrip
      end

      def chars_middle(text, count, omission)
        limit = count - omission.length
        return omission[0, count] if limit <= 0

        half = limit / 2
        tail = limit - half
        text[0, half] + omission + text[text.length - tail, tail]
      end

      # Take the first `n` bytes of `text`, then walk back to the nearest
      # valid UTF-8 boundary so no partial codepoint is emitted. Returns a
      # UTF-8-encoded String.
      def safe_byte_slice(text, n)
        return +'' if n <= 0

        sliced = text.byteslice(0, n) || +''
        sliced.force_encoding(Encoding::UTF_8)
        sliced = sliced.byteslice(0, sliced.bytesize - 1) until sliced.valid_encoding? || sliced.empty?
        sliced.force_encoding(Encoding::UTF_8)
      end

      # Take the last `n` bytes of `text`, then walk forward to the nearest
      # valid UTF-8 boundary.
      def safe_byte_slice_end(text, n)
        return +'' if n <= 0

        start = [text.bytesize - n, 0].max
        sliced = text.byteslice(start, text.bytesize - start) || +''
        sliced.force_encoding(Encoding::UTF_8)
        sliced = sliced.byteslice(1, sliced.bytesize - 1) until sliced.valid_encoding? || sliced.empty?
        sliced.force_encoding(Encoding::UTF_8)
      end

      def bytes_end(text, byte_count, omission, omission_bytes)
        head_budget = byte_count - omission_bytes
        safe_byte_slice(text, head_budget) + omission
      end

      def bytes_start(text, byte_count, omission, omission_bytes)
        tail_budget = byte_count - omission_bytes
        omission + safe_byte_slice_end(text, tail_budget)
      end

      def bytes_middle(text, byte_count, omission, omission_bytes)
        body = byte_count - omission_bytes
        half = body / 2
        tail = body - half
        safe_byte_slice(text, half) + omission + safe_byte_slice_end(text, tail)
      end
    end
  end
end
