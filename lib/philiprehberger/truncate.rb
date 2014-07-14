# frozen_string_literal: true

require_relative 'truncate/version'

module Philiprehberger
  module Truncate
    class Error < StandardError; end

    DEFAULT_OMISSION = '...'

    OPENING_TAG = /<(\w+)(?:\s[^>]*)?>/.freeze
    CLOSING_TAG = %r{</(\w+)>}.freeze
    SELF_CLOSING_TAG = %r{<\w+(?:\s[^>]*)?\s*/>}.freeze
    TAG_PATTERN = %r{</?[^>]+>}.freeze
    SENTENCE_BOUNDARY = /(?<=[.!?])\s+/.freeze

    # Truncate text to a given number of words
    #
    # @param text [String] the input string
    # @param count [Integer] maximum number of words
    # @param omission [String] string to append when truncated
    # @return [String] the truncated string
    # @raise [Error] if text is not a string or count is not a positive integer
    def self.words(text, count, omission: DEFAULT_OMISSION)
      validate!(text, count)
      return '' if text.empty?

      parts = text.split(/\s+/)
      return text if parts.length <= count

      parts.first(count).join(' ') + omission
    end

    # Truncate text to a given number of characters at word boundaries
    #
    # @param text [String] the input string
    # @param count [Integer] maximum number of characters
    # @param omission [String] string to append when truncated
    # @return [String] the truncated string
    # @raise [Error] if text is not a string or count is not a positive integer
    def self.chars(text, count, omission: DEFAULT_OMISSION)
      validate!(text, count)
      return '' if text.empty?
      return text if text.length <= count

      limit = count - omission.length
      return omission[0, count] if limit <= 0

      truncated = text[0, limit]
      # Find last word boundary, but if there isn't one just use the limit
      boundary = truncated.rindex(/\s/)
      truncated = truncated[0, boundary] if boundary
      truncated.rstrip + omission
    end

    # Truncate HTML to a given number of visible characters, closing unclosed tags
    #
    # @param html [String] the HTML string
    # @param count [Integer] maximum number of visible characters
    # @param omission [String] string to append when truncated
    # @return [String] the truncated HTML with closed tags
    # @raise [Error] if html is not a string or count is not a positive integer
    def self.html(html, count, omission: DEFAULT_OMISSION)
      validate!(html, count)
      return '' if html.empty?

      open_tags = []
      visible_chars = 0
      result = +''
      scanner = StringScanner.new(html)

      while !scanner.eos? && visible_chars < count
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

    # Truncate text to a given number of sentences
    #
    # @param text [String] the input string
    # @param count [Integer] maximum number of sentences
    # @param omission [String] string to append when truncated
    # @return [String] the truncated string
    # @raise [Error] if text is not a string or count is not a positive integer
    def self.sentences(text, count, omission: DEFAULT_OMISSION)
      validate!(text, count)
      return '' if text.empty?

      parts = text.split(SENTENCE_BOUNDARY)
      return text if parts.length <= count

      parts.first(count).join(' ') + omission
    end

    # @api private
    def self.validate!(text, count)
      raise Error, 'text must be a String' unless text.is_a?(String)
      raise Error, 'count must be a positive Integer' unless count.is_a?(Integer) && count.positive?
    end
    private_class_method :validate!
  end
end

require 'strscan'
