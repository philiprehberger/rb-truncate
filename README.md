# philiprehberger-truncate

[![Tests](https://github.com/philiprehberger/rb-truncate/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-truncate/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-truncate.svg)](https://rubygems.org/gems/philiprehberger-truncate)
[![License](https://img.shields.io/github/license/philiprehberger/rb-truncate)](LICENSE)

Smart string truncation with word boundaries, HTML safety, and multi-byte support

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-truncate"
```

Or install directly:

```bash
gem install philiprehberger-truncate
```

## Usage

```ruby
require "philiprehberger/truncate"

# Truncate by words
Philiprehberger::Truncate.words('one two three four five', 3)
# => "one two three..."

# Truncate by characters at word boundary
Philiprehberger::Truncate.chars('hello beautiful world', 20)
# => "hello beautiful..."

# Truncate by sentences
Philiprehberger::Truncate.sentences('First sentence. Second sentence. Third.', 2)
# => "First sentence. Second sentence...."

# HTML-safe truncation (closes unclosed tags)
Philiprehberger::Truncate.html('<p><strong>hello world</strong></p>', 5)
# => "<p><strong>hello...</strong></p>"

# Custom omission
Philiprehberger::Truncate.words('one two three', 2, omission: ' [more]')
# => "one two [more]"
```

## API

| Method | Description |
|--------|-------------|
| `Truncate.words(text, count, omission: '...')` | Truncate text to N words with omission string |
| `Truncate.chars(text, count, omission: '...')` | Truncate text to N characters at a word boundary |
| `Truncate.sentences(text, count, omission: '...')` | Truncate text to N sentences |
| `Truncate.html(html, char_count, omission: '...')` | HTML-safe truncation that preserves and closes tags |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
