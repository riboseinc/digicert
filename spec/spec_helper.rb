require "dotenv/load"
require "webmock/rspec"
require "bundler/setup"
require "digicert"

Dir["./spec/support/**/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :all do
    Digicert.configure do |digicert_config|
      digicert_config.debug_mode = false
      digicert_config.api_key = ENV["SECRET_DEV_API_KEY"] || "SECRET_KEY"
    end
  end

  # Skip the actual API calls by default
  config.filter_run_excluding api_call: true

  # Allow the net_connection when we actually want to
  # perform an actual API reques
  #
  config.before :each, api_call: true do
    Digicert.configuration.debug_mode = true
    WebMock.allow_net_connect!
  end

  config.include Digicert::FakeDigicertApi
end
