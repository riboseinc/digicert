require "spec_helper"

RSpec.describe Digicert::ClientCertificate::PrivatePremium do
  describe ".create" do
    it "creates a new order for a client private premium certificate" do
      stub_digicert_order_create_api("private_client_premium", order_attributes)
      order = Digicert::ClientCertificate::PrivatePremium.create(order_attributes)

      expect(order.id).not_to be_nil
    end
  end

  def order_attributes
    {
      certificate: {
        organization_units: ["Developers"],

        csr: "----- CSR HERE -----",
        emails: ["a.name@example.com"],
        common_name: "A Name",
        signature_hash: "sha256",
      },
      organization: { id: "12345" },
      validity_years: 3,
      auto_renew: nil,
      container: { id: "654321" },
      payment_method: "balance"
    }
  end
end
