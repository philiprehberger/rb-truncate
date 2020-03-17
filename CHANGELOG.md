# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
