require "bundler/setup"
require "digicert/api"
require "digicert/config"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :all do
    Digicert.configure do |digicert_config|
      digicert_config.api_host = "www.digicert.com"
      digicert_config.base_path = "services/v2"
    end
  end
end
