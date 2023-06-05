# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in sort_param.gemspec
gemspec

if ENV.fetch("COVERAGE", nil) == "true"
  gem "simplecov"
  gem "simplecov-cobertura"
end

gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
gem "rubocop", "~> 1.21"
