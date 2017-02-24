require "spec_helper"
require "digicert/request"

RSpec.describe Digicert::Request do
  describe "#run" do
    it "retrieves a resource via a specified http verb" do
      stub_ping_reqeust_via_get
      response = Digicert::Request.new(:get, "ping").run

      expect(response.code.to_i).to eq(200)
      expect(response.class).to eq(Net::HTTPOK)
    end
  end

  describe "#parse" do
    it "retrives and parse the resource to object" do
      stub_ping_reqeust_via_get
      response = Digicert::Request.new(:get, "ping").parse

      expect(response.data).to eq("Pong!")
    end
  end

  def stub_ping_reqeust_via_get
    # This helper method is defined in `spec/support/fake_digicert_api`
    # all it does it verify the reqeust verb, end_point and and data along
    # with the digicert reqeust headers, and once satisfied then it will
    # reponse with an identical json file that can be found in `fixtures`
    #
    stub_api_response(:get, "ping", filename: "ping")
  end
end
