require "spec_helper"

RSpec.describe Digicert::ClientCertificate::DigitalSignaturePlus do
  describe ".create" do
    it "creates a new order for a digital signature plus certificate" do
      stub_digicert_order_create_api(
        "client_digital_signature_plus", order_attributes,
      )

      order = Digicert::ClientCertificate::DigitalSignaturePlus.create(
        order_attributes,
      )

      expect(order.id).not_to be_nil
    end
  end

  def order_attributes
    {
      certificate: {
        # Required for certificate
        emails: ["email@example.com", "email1@example.com"],
        common_name: "Full Name",
        signature_hash: "sha256",
      },
      organization: { id: 117483 },
      validity_years: 3,
      auto_renew: 10,
      renewal_of_order_id: 314152,
    }
  end
end
