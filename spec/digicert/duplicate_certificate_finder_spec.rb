require "spec_helper"

RSpec.describe Digicert::DuplicateCertificateFinder do
  describe ".find" do
    context "approved request" do
      it "finds the duplicate certificate" do
        request_id = 123_456_789

        stub_digicert_certificate_request_fetch_api(request_id)
        stub_digicert_order_duplications_api(order_id)

        certificate = Digicert::DuplicateCertificateFinder.find_by(
          request_id: request_id,
        )

        expect(certificate.id).not_to be_nil
      end
    end

    context "pending request" do
      it "returns RequestError with a message" do
        request_id = 456_789_012
        stub_digicert_certificate_request_fetch_api(
          request_id, "certificate_request_pending"
        )

        expect do
          Digicert::DuplicateCertificateFinder.find_by(request_id: request_id)
        end.to raise_error(Digicert::Errors::RequestError)
      end
    end
  end

  def order_id
    # Fetching an existing request returns the fixtures file we
    # wrote as certificate_request.json, and that order_id is
    # being used to fetched the duplications, so for this use
    # case let's keep it simple and hardcode the value for now
    #
    @order_id ||= 542757
  end
end
