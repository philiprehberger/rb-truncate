# philiprehberger-truncate

[![Tests](https://github.com/philiprehberger/rb-truncate/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-truncate/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-truncate.svg)](https://rubygems.org/gems/philiprehberger-truncate)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-truncate)](https://github.com/philiprehberger/rb-truncate/commits/main)

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

Philiprehberger::Truncate.words('one two three four five', 3)
# => "one two three..."
```

### Character Truncation

Truncate to a character limit, breaking at the nearest word boundary:

```ruby
Philiprehberger::Truncate.chars('hello beautiful world', 20)
# => "hello beautiful..."

# Custom omission string
Philiprehberger::Truncate.chars('hello beautiful world', 20, omission: ' [more]')
# => "hello beautiful [more]"
```

### Sentence Truncation

Keep the first N complete sentences:

```ruby
Philiprehberger::Truncate.sentences('First sentence. Second sentence. Third.', 2)
# => "First sentence. Second sentence...."
```

### HTML-Safe Truncation

Truncate by visible characters while preserving and closing HTML tags:

```ruby
Philiprehberger::Truncate.html('<p><strong>hello world</strong></p>', 5)
# => "<p><strong>hello...</strong></p>"
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

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-truncate)

🐛 [Report issues](https://github.com/philiprehberger/rb-truncate/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-truncate/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
