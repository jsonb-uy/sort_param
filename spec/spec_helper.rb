# frozen_string_literal: true

Dir[File.expand_path("support/*.rb", __dir__)].sort.each { |f| require f }

if ENV.fetch("COVERAGE", nil) == "true"
  require "simplecov-cobertura"
  require "simplecov"

  SimpleCov.start
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

require "sort_param"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
