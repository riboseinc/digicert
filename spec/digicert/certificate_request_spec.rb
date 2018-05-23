require "spec_helper"

RSpec.describe Digicert::CertificateRequest do
  describe ".all" do
    it "retrieves the lists of certificate requests" do
      stub_digicert_certificate_request_list_api
      certificate_requests = Digicert::CertificateRequest.all

      expect(certificate_requests.count).to eq(2)
      expect(certificate_requests.first.id).not_to be_nil
      expect(certificate_requests.first.requester.first_name).not_to be_nil
    end
  end

  describe ".fetch" do
    it "retrieves the specified certificate request" do
      request_id = 123_456_789

      stub_digicert_certificate_request_fetch_api(request_id)
      certificate_request = Digicert::CertificateRequest.fetch(request_id)

      expect(certificate_request.order.id).not_to be_nil
      expect(certificate_request.status).to eq("approved")
      expect(certificate_request.requester.first_name).not_to be_nil
    end
  end

  describe ".update" do
    it "updates the specified ceritfiicate request status" do
      request_id = 123_456_789
      stub_digicert_certificate_request_update_api(
        request_id, request_status_attributes
      )

      status_update = Digicert::CertificateRequest.update(
        request_id, request_status_attributes
      )

      expect(status_update.code).to eq("204")
    end
  end

  def request_status_attributes
    {
      status: "approved",
      processor_comment: "Your domain is approved",
    }
  end
end
