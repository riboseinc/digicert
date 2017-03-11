require "spec_helper"

RSpec.describe "Request Management" do
  describe "fetching a specific request", api_call: true do
    it "fetches the details for a specific request" do
      request = Digicert::CertificateRequest.fetch(request_id)

      expect(request.status).to eq("approved")
      expect(request.order.organization.name).to eq("Ribose Inc.")
      expect(request.order.certificate.common_name).to eq("ribosetest.com")
    end
  end

  def request_id
    @request_id ||= requests.first.id
  end

  def requests
    # We are intentionally making this API call to ensure
    # the `.all` interface is working as it should have.
    #
    @requests ||= Digicert::CertificateRequest.all
  end
end
