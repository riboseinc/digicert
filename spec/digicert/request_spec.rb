require "spec_helper"
require "digicert/request"

RSpec.describe Digicert::Request do
  describe "#run" do
    context "with 2xx response" do
      it "retrieves a resource via a specified http verb" do
        stub_ping_request_via_get
        response = Digicert::Request.new(:get, "ping").run

        expect(response.code.to_i).to eq(200)
        expect(response.class).to eq(Net::HTTPOK)
      end
    end

    context "with 4xx, 5xx responses" do
      it "raises the proper response error" do
        stub_invalid_ping_request_via_get
        request = Digicert::Request.new(:get, "ping")

        expect{ request.run }.to raise_error(/not_found\|route/)
      end
    end
  end

  describe "#parse" do
    it "retrives and parse the resource to object" do
      stub_ping_request_via_get
      response = Digicert::Request.new(:get, "ping").parse

      expect(response.data).to eq("Pong!")
    end
  end

  def stub_ping_request_via_get
    # This helper method is defined in `spec/support/fake_digicert_api`
    # all it does it verify the request verb, end_point and and data along
    # with the digicert request headers, and once satisfied then it will
    # reponse with an identical json file that can be found in `fixtures`
    #
    stub_api_response(:get, "ping", filename: "ping")
  end

  def stub_invalid_ping_request_via_get
    stub_api_response(:get, "ping", filename: "errors", status: 404)
  end
end
