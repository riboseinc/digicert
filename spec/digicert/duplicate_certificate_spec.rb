require "spec_helper"

RSpec.describe Digicert::DuplicateCertificate do
  describe ".all" do
    it "list all duplicate certificates" do
      order_id = 123_456_789

      stub_digicert_order_duplications_api(order_id)
      certificates = Digicert::DuplicateCertificate.all(order_id: order_id)

      expect(certificates.first.id).not_to be_nil
      expect(certificates.first.status).to eq("approved")
    end
  end
end
