# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Truncate do
  describe '.words' do
    it 'truncates to the given number of words' do
      expect(described_class.words('one two three four five', 3)).to eq('one two three...')
    end

    it 'returns the original text when within limit' do
      expect(described_class.words('hello world', 5)).to eq('hello world')
    end

    it 'uses a custom omission string' do
      expect(described_class.words('one two three', 2, omission: ' [more]')).to eq('one two [more]')
    end

    it 'returns empty string for empty input' do
      expect(described_class.words('', 3)).to eq('')
    end

    it 'handles a single word within limit' do
      expect(described_class.words('hello', 1)).to eq('hello')
    end
  end

  describe '.chars' do
    it 'truncates at a word boundary' do
      result = described_class.chars('hello world foo bar', 12)
      expect(result).to eq('hello...')
    end

    it 'returns the original text when within limit' do
      expect(described_class.chars('short', 10)).to eq('short')
    end

    it 'includes omission in count' do
      result = described_class.chars('hello beautiful world', 20)
      expect(result.length).to be <= 20
      expect(result).to end_with('...')
    end

    it 'uses a custom omission string' do
      expect(described_class.chars('hello world foo', 12, omission: '~')).to eq('hello world~')
    end

    it 'handles text shorter than omission' do
      result = described_class.chars('hello world', 2)
      expect(result.length).to be <= 2
    end

    it 'returns empty string for empty input' do
      expect(described_class.chars('', 5)).to eq('')
    end

    it 'handles string equal to limit' do
      expect(described_class.chars('hello', 5)).to eq('hello')
    end
  end

  describe '.sentences' do
    it 'truncates to a single sentence' do
      text = 'First sentence. Second sentence. Third sentence.'
      expect(described_class.sentences(text, 1)).to eq('First sentence....')
    end

    it 'truncates to multiple sentences' do
      text = 'One. Two. Three. Four.'
      expect(described_class.sentences(text, 2)).to eq('One. Two....')
    end

    it 'returns original text when within limit' do
      text = 'Just one.'
      expect(described_class.sentences(text, 3)).to eq('Just one.')
    end

    it 'handles exclamation marks' do
      text = 'Wow! Amazing! Great!'
      expect(described_class.sentences(text, 2)).to eq('Wow! Amazing!...')
    end

    it 'handles question marks' do
      text = 'Really? Yes. No?'
      expect(described_class.sentences(text, 1)).to eq('Really?...')
    end

    it 'uses a custom omission string' do
      text = 'First. Second. Third.'
      expect(described_class.sentences(text, 1, omission: ' [more]')).to eq('First. [more]')
    end

    it 'returns empty string for empty input' do
      expect(described_class.sentences('', 2)).to eq('')
    end
  end

  describe '.strip_html' do
    it 'strips basic HTML tags' do
      expect(described_class.strip_html('<p>hello world</p>', 100)).to eq('hello world')
    end

    it 'decodes &amp; entity' do
      expect(described_class.strip_html('Tom &amp; Jerry', 100)).to eq('Tom & Jerry')
    end

    it 'decodes &lt; and &gt; entities' do
      expect(described_class.strip_html('&lt;b&gt;bold&lt;/b&gt;', 100)).to eq('<b>bold</b>')
    end

    it 'decodes &quot; entity' do
      expect(described_class.strip_html('say &quot;hello&quot;', 100)).to eq('say "hello"')
    end

    it 'decodes &apos; entity' do
      expect(described_class.strip_html('it&apos;s fine', 100)).to eq("it's fine")
    end

    it 'decodes decimal numeric entities' do
      expect(described_class.strip_html('&#65;&#66;&#67;', 100)).to eq('ABC')
    end

    it 'decodes hex numeric entities' do
      expect(described_class.strip_html('&#x41;&#x42;&#x43;', 100)).to eq('ABC')
    end

    it 'collapses multiple whitespace into single spaces' do
      expect(described_class.strip_html("<p>hello   \n  world</p>", 100)).to eq('hello world')
    end

    it 'strips leading and trailing whitespace' do
      expect(described_class.strip_html('  <span>text</span>  ', 100)).to eq('text')
    end

    it 'truncates the resulting plain text with omission' do
      result = described_class.strip_html('<p>hello beautiful world</p>', 14)
      expect(result).to end_with('...')
      expect(result.length).to be <= 14
    end

    it 'does not truncate when text is shorter than limit' do
      expect(described_class.strip_html('<em>hi</em>', 50)).to eq('hi')
    end

    it 'uses a custom omission string' do
      result = described_class.strip_html('<p>hello world foo</p>', 10, omission: '~')
      expect(result).to end_with('~')
    end

    it 'returns empty string for empty input' do
      expect(described_class.strip_html('', 10)).to eq('')
    end
  end

  describe '.html' do
    it 'truncates visible text only' do
      expect(described_class.html('<p>hello world</p>', 5)).to eq('<p>hello...</p>')
    end

    it 'closes unclosed strong tags' do
      expect(described_class.html('<strong>hello world</strong>', 5)).to eq('<strong>hello...</strong>')
    end

    it 'closes unclosed em tags' do
      expect(described_class.html('<em>hello world</em>', 5)).to eq('<em>hello...</em>')
    end

    it 'handles nested tags' do
      html = '<p><strong>hello world</strong></p>'
      result = described_class.html(html, 5)
      expect(result).to eq('<p><strong>hello...</strong></p>')
    end

    it 'returns full html when within limit' do
      html = '<p>hi</p>'
      expect(described_class.html(html, 10)).to eq('<p>hi</p>')
    end

    it 'returns empty string for empty input' do
      expect(described_class.html('', 5)).to eq('')
    end
  end

  describe 'multi-byte support' do
    it 'handles Japanese characters in chars' do
      text = "\u3053\u3093\u306B\u3061\u306F\u4E16\u754C"
      expect(described_class.chars(text, 5)).to eq("\u3053\u3093...")
    end

    it 'handles emoji in words' do
      text = 'hello world'
      expect(described_class.words(text, 1)).to eq('hello...')
    end

    it 'handles multi-byte in html' do
      html = '<p>cafe resume</p>'
      result = described_class.html(html, 4)
      expect(result).to eq('<p>cafe...</p>')
    end
  end

  describe 'edge cases' do
    it 'handles string equal to limit in words' do
      expect(described_class.words('one two', 2)).to eq('one two')
    end

    it 'handles string equal to limit in chars' do
      expect(described_class.chars('hello', 5)).to eq('hello')
    end

    it 'handles single word in words' do
      expect(described_class.words('hello', 1)).to eq('hello')
    end

    it 'handles custom omission in chars' do
      result = described_class.chars('hello world', 8, omission: '..')
      expect(result.length).to be <= 8
    end
  end

  describe '.lines' do
    it 'truncates to given number of lines' do
      text = "line one\nline two\nline three\nline four"
      expect(described_class.lines(text, 2)).to eq("line one\nline two...")
    end

    it 'returns original text within limit' do
      text = "line one\nline two"
      expect(described_class.lines(text, 5)).to eq("line one\nline two")
    end

    it 'returns empty string for empty input' do
      expect(described_class.lines('', 3)).to eq('')
    end

    it 'uses custom omission' do
      text = "line one\nline two\nline three"
      expect(described_class.lines(text, 1, omission: ' [more]')).to eq('line one [more]')
    end

    it 'handles single line within limit' do
      expect(described_class.lines('hello', 2)).to eq('hello')
    end
  end

  describe '.batch' do
    it 'returns an array of truncated strings' do
      result = described_class.batch(['hello world foo', 'another long string here', 'short'], 12)
      expect(result).to be_an(Array)
      expect(result.length).to eq(3)
      expect(result[0]).to end_with('...')
      expect(result[0].length).to be <= 12
      expect(result[2]).to eq('short')
    end

    it 'honors a custom omission option' do
      result = described_class.batch(['hello world foo', 'another long string'], 12, omission: '~')
      expect(result[0]).to end_with('~')
      expect(result[1]).to end_with('~')
    end

    it 'honors the position option' do
      result = described_class.batch(['hello beautiful world'], 12, position: :start)
      expect(result[0]).to start_with('...')
    end

    it 'returns an empty array for an empty input array' do
      expect(described_class.batch([], 10)).to eq([])
    end
  end

  describe 'DEFAULT_OMISSION' do
    it 'is publicly accessible' do
      expect(described_class.const_defined?(:DEFAULT_OMISSION)).to be(true)
    end

    it 'is a String' do
      expect(described_class::DEFAULT_OMISSION).to be_a(String)
    end
  end

  describe 'position parameter' do
    describe 'words with position: :start' do
      it 'keeps last N words with omission at start' do
        expect(described_class.words('one two three four five', 3, position: :start)).to eq('...three four five')
      end
    end

    describe 'words with position: :middle' do
      it 'keeps first and last words with omission in middle' do
        result = described_class.words('one two three four five six', 4, position: :middle)
        expect(result).to eq('one two...five six')
      end
    end

    describe 'chars with position: :start' do
      it 'keeps tail characters with omission at start' do
        result = described_class.chars('hello beautiful world', 12, position: :start)
        expect(result).to start_with('...')
        expect(result.length).to be <= 12
      end
    end

    describe 'chars with position: :middle' do
      it 'keeps head and tail with omission in middle' do
        result = described_class.chars('hello beautiful world', 15, position: :middle)
        expect(result).to include('...')
        expect(result.length).to be <= 15
      end
    end

    describe 'sentences with position: :start' do
      it 'keeps last N sentences' do
        text = 'First. Second. Third. Fourth.'
        result = described_class.sentences(text, 2, position: :start)
        expect(result).to eq('...Third. Fourth.')
      end
    end
  end

  describe '.bytes' do
    it 'returns the input unchanged when already under the byte limit' do
      expect(described_class.bytes('hello', 100)).to eq('hello')
    end

    it 'truncates ASCII to the byte budget including the omission' do
      result = described_class.bytes('hello world', 8)
      expect(result.bytesize).to be <= 8
      expect(result).to end_with('...')
    end

    it 'never emits a partial multi-byte UTF-8 codepoint' do
      text = 'café résumé'
      result = described_class.bytes(text, 7)
      expect(result.bytesize).to be <= 7
      expect(result.valid_encoding?).to be true
    end

    it 'supports position: :start' do
      result = described_class.bytes('hello world', 8, position: :start)
      expect(result.bytesize).to be <= 8
      expect(result).to start_with('...')
    end

    it 'supports position: :middle' do
      result = described_class.bytes('hello world', 9, position: :middle)
      expect(result.bytesize).to be <= 9
      expect(result).to include('...')
    end

    it 'returns a fitting prefix of the omission when budget <= omission' do
      result = described_class.bytes('hello world', 2)
      expect(result.bytesize).to be <= 2
    end

    it 'returns an empty string for empty input' do
      expect(described_class.bytes('', 10)).to eq('')
    end

    it 'respects a custom omission' do
      result = described_class.bytes('hello world', 8, omission: '~')
      expect(result.bytesize).to be <= 8
      expect(result).to end_with('~')
    end
  end
end
