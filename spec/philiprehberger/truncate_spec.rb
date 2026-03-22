# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Truncate do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe '.words' do
    it 'truncates to the given number of words' do
      expect(described_class.words('one two three four five', 3)).to eq('one two three...')
    end

    it 'returns the original text when within limit' do
      expect(described_class.words('hello world', 5)).to eq('hello world')
    end

    it 'handles trailing whitespace' do
      expect(described_class.words('one two three  ', 2)).to eq('one two...')
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

    it 'raises Error for non-string input' do
      expect { described_class.words(123, 3) }.to raise_error(described_class::Error)
    end

    it 'raises Error for non-positive count' do
      expect { described_class.words('hello', 0) }.to raise_error(described_class::Error)
    end
  end

  describe '.chars' do
    it 'truncates at a word boundary' do
      expect(described_class.chars('hello beautiful world', 20)).to eq('hello beautiful...')
    end

    it 'returns the original text when within limit' do
      expect(described_class.chars('short', 10)).to eq('short')
    end

    it 'truncates at a complete word boundary' do
      result = described_class.chars('hello world foo bar', 12)
      # Should truncate to 'hello...' (9 chars fits in limit=12-3=9)
      expect(result).to eq('hello...')
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

    it 'raises Error for non-string input' do
      expect { described_class.chars(nil, 5) }.to raise_error(described_class::Error)
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

    it 'preserves self-closing tags' do
      html = '<p>hello<br/>world</p>'
      result = described_class.html(html, 5)
      expect(result).to eq('<p>hello...</p>')
    end

    it 'returns full html when within limit' do
      html = '<p>hi</p>'
      expect(described_class.html(html, 10)).to eq('<p>hi</p>')
    end

    it 'returns empty string for empty input' do
      expect(described_class.html('', 5)).to eq('')
    end

    it 'raises Error for non-string input' do
      expect { described_class.html(42, 5) }.to raise_error(described_class::Error)
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

    it 'raises Error for non-string input' do
      expect { described_class.sentences(123, 2) }.to raise_error(described_class::Error)
    end
  end

  describe 'multi-byte support' do
    it 'handles Japanese characters in chars' do
      text = 'こんにちは世界'
      expect(described_class.chars(text, 5)).to eq('こん...')
    end

    it 'handles emoji in words' do
      text = 'hello world'
      expect(described_class.words(text, 1)).to eq('hello...')
    end

    it 'handles accented characters in chars' do
      text = 'cafe resume naive'
      expect(described_class.chars(text, 10)).to eq('cafe...')
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
  end
end
