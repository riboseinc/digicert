require "spec_helper"
require "digicert/config"

RSpec.describe Digicert::Config do
  after { restore_default_config }

  describe ".configuration" do
    it "returns the current configuration" do
      configuration = Digicert.configuration

      expect(configuration.api_host).to eq("www.digicert.com")
      expect(configuration.base_path).to eq("services/v2")
    end
  end

  describe ".configure" do
    it "allows us to set our custom configuration" do
      api_host = "www.example.com"
      base_path = "ping"

      Digicert.configure do |config|
        config.api_host = api_host
        config.base_path = base_path
      end

      expect(Digicert.configuration.api_host).to eq(api_host)
      expect(Digicert.configuration.base_path).to eq(base_path)
      expect(Digicert.configuration.debug_mode?).to be_falsey
      expect(
        Digicert.configuration.response_klass,
      ).to eq(Digicert::ResponseObject)
    end
  end

  def restore_default_config
    Digicert.configuration.api_host = "www.digicert.com"
    Digicert.configuration.base_path = "services/v2"
  end
end
