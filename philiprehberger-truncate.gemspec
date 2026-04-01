# frozen_string_literal: true

require_relative 'lib/philiprehberger/truncate/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-truncate'
  spec.version = Philiprehberger::Truncate::VERSION
  spec.authors = ['philiprehberger']
  spec.email = ['philiprehberger@users.noreply.github.com']

  spec.summary = 'Smart string truncation with word boundaries, HTML safety, and multi-byte support'
  spec.description = 'Truncate strings by word count, character count, or sentence count with ' \
                     'word-boundary awareness. Includes HTML-safe mode that properly closes open tags ' \
                     'and handles multi-byte characters correctly.'
  spec.homepage      = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-truncate'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/philiprehberger/rb-truncate'
  spec.metadata['changelog_uri']         = 'https://github.com/philiprehberger/rb-truncate/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/philiprehberger/rb-truncate/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
