require "spec_helper"
require "digicert/request"

RSpec.describe Digicert::Request do
  describe "#run" do
    it "retrieves a resource via a specified http verb" do
      stub_ping_reqeust_via_get
      response = Digicert::Request.new(:get, "ping").run

      expect(response.data).to eq("Pong!")
    end
  end

  def stub_ping_reqeust_via_get
    stub_request(:get, "https://www.digicert.com/services/v2/ping").
      with(headers: { "X-Dc-Devkey"=> Digicert.configuration.api_key }).
      to_return(status: 200, body: { data: "Pong!"}.to_json )
  end
end
