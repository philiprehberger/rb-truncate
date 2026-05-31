# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2026-05-30

### Added
- `Truncate.bytes(text, byte_count, omission: '...', position: :end)` — truncate by byte length while preserving UTF-8 boundaries so no partial multi-byte codepoint is emitted. Useful for database column limits, HTTP header budgets, and message-size caps. Supports `:end`, `:start`, and `:middle` positions.
- Card image to README per readme-template guide

## [0.4.0] - 2026-04-26

### Added
- `Truncate.batch(strings, length, **opts)` — truncate many strings with shared options in one call
- `Truncate::DEFAULT_OMISSION` — public constant exposing the default omission string

## [0.3.0] - 2026-04-16

### Added
- `Truncate.strip_html(html, length, omission:)` method that strips HTML tags, decodes common HTML entities, collapses whitespace, and truncates the resulting plain text

## [0.2.0] - 2026-04-01

### Added
- `Truncate.lines(text, count, omission:)` method for line-based truncation
- `position:` parameter (`:end`, `:start`, `:middle`) for `words`, `chars`, and `sentences` methods

### Fixed
- Fix gemspec authors to `['Philip Rehberger']`
- Fix gemspec email to `['me@philiprehberger.com']`
- Fix gemspec required_ruby_version to `'>= 3.1.0'`

## [0.1.10] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.9] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.8] - 2026-03-26

### Changed
- Add Sponsor badge to README
- Fix License section format


## [0.1.7] - 2026-03-24

### Changed
- Add Usage subsections to README for better feature discoverability

## [0.1.6] - 2026-03-24

### Fixed
- Standardize README code examples to use double-quote require statements

## [0.1.5] - 2026-03-24

### Fixed
- Standardize README API section to table format

## [0.1.4] - 2026-03-23

### Fixed
- Standardize README to match template (installation order, code fences, license section, one-liner format)
- Update gemspec summary to match README description

## [0.1.3] - 2026-03-22

### Added

- `Truncate.words` to truncate text to N words
- `Truncate.chars` to truncate text to N characters at word boundaries
- `Truncate.sentences` to truncate text to N sentences
- `Truncate.html` for HTML-safe truncation that closes unclosed tags
- Multi-byte character support throughout all methods
- Custom omission string support for all methods

[0.1.0]: https://github.com/philiprehberger/rb-truncate/releases/tag/v0.1.0
