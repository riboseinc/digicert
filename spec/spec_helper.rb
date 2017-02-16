require "webmock/rspec"
require "bundler/setup"
require "digicert/api"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :all do
    Digicert.configure do |digicert_config|
      digicert_config.api_key = "SECRET_DEV_API_KEY"
    end
  end
end
