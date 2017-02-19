require "spec_helper"

RSpec.describe Digicert::CertificateOrder do
  describe ".fetch" do
    it "retrieves the specific certificate order" do
      order_id = 123_456_789

      stub_digicert_certificate_order_fetch_api(order_id)
      certificate_order = Digicert::CertificateOrder.fetch(order_id)

      expect(certificate_order.id).not_to be_nil
      expect(certificate_order.status).to eq("approved")
      expect(certificate_order.certificate.id).not_to be_nil
    end
  end
end
