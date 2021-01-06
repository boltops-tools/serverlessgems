require "bundler/setup"
require "jets/gems"

ENV['JETS_ROOT'] = 'spec/fixtures/project'
ENV['HOME'] = 'spec/fixtures/home'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
