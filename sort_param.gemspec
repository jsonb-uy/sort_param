# frozen_string_literal: true

require_relative "lib/sort_param/version"

Gem::Specification.new do |spec|
  spec.name = "sort_param"
  spec.version = SortParam::VERSION
  spec.authors = ['Uy Jayson B']
  spec.email = ["uy.json.dev@gmail.com"]

  spec.summary = "Sort records using a sort query parameter à la JSON-API style"
  spec.description = "Sort records using a sort query parameter à la JSON-API style"
  spec.homepage = "https://github.com/jsonb-uy/sort_param"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jsonb-uy/sort_param"
  spec.metadata["changelog_uri"] = "https://github.com/jsonb-uy/sort_param/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/github/jsonb-uy/sort_param/main"
  spec.metadata["bug_tracker_uri"] = "https://github.com/jsonb-uy/sort_param/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*']
  spec.require_paths = ["lib"]

  spec.bindir        = "bin"
  spec.executables   = []
end
