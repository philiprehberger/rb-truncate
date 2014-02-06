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
gem 'philiprehberger-truncate'
```

Or install directly:

```bash
gem install philiprehberger-truncate
```

## Usage

```ruby
require 'philiprehberger/truncate'

Philiprehberger::Truncate.words('one two three four five', 3)  # => "one two three..."
Philiprehberger::Truncate.chars('hello beautiful world', 16)   # => "hello beautiful..."
```

### Truncate by Words

```ruby
Philiprehberger::Truncate.words('one two three four five', 3)
# => "one two three..."

Philiprehberger::Truncate.words('one two three', 2, omission: ' [more]')
# => "one two [more]"
```

### Truncate by Characters

Finds the last word boundary before the limit:

```ruby
Philiprehberger::Truncate.chars('hello beautiful world', 16)
# => "hello beautiful..."

Philiprehberger::Truncate.chars('hello world foo', 12, omission: '~')
# => "hello world~"
```

### HTML-Safe Truncation

Truncates visible text and closes any unclosed tags:

```ruby
Philiprehberger::Truncate.html('<p><strong>hello world</strong></p>', 5)
# => "<p><strong>hello...</strong></p>"
```

### Truncate by Sentences

```ruby
Philiprehberger::Truncate.sentences('First sentence. Second sentence. Third.', 2)
# => "First sentence. Second sentence...."
```

### Multi-Byte Support

All methods handle multi-byte characters correctly:

```ruby
Philiprehberger::Truncate.chars('こんにちは世界', 5)
# => "こん..."
```

## API

| Method | Description |
|--------|-------------|
| `Truncate.words(text, count, omission: '...')` | Truncate to N words |
| `Truncate.chars(text, count, omission: '...')` | Truncate to N characters at word boundary |
| `Truncate.html(html, count, omission: '...')` | HTML-safe truncation, closes unclosed tags |
| `Truncate.sentences(text, count, omission: '...')` | Truncate to N sentences |

## Development

```bash
bundle install
bundle exec rspec      # Run tests
bundle exec rubocop    # Check code style
```

## License

MIT
