require "spec_helper"

RSpec.describe Digicert::ClientCertificate::Premium do
  describe ".create" do
    it "creates a new order for a client premium certificate" do
      stub_digicert_order_create_api("client_premium", order_attributes)
      order = Digicert::ClientCertificate::Premium.create(order_attributes)

      expect(order.id).not_to be_nil
    end
  end

  def order_attributes
    {
      certificate: {
        organization_units: ["Developer Operations"],
        server_platform: { id: 45 },
        profile_option: "some_ssl_profile",

        # Required for certificate
        csr: "------ [CSR HERE] ------",
        emails: ["email@example.com", "email1@example.com"],
        common_name: "digicert.com",
        signature_hash: "sha256",
      },
      organization: { id: 117483 },
      validity_years: 3,
      custom_expiration_date: "2017-05-18",
      comments: "Comments for the the approver",
      disable_renewal_notifications: false,
      renewal_of_order_id: 314152,
    }
  end
end
