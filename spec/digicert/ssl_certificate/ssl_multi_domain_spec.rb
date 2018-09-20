require "spec_helper"

RSpec.describe Digicert::SSLCertificate::SSLMultiDomain do
  describe ".create" do
    it "creates a new order for a ssl multi domain certificate" do
      stub_digicert_order_create_api(
        "ssl_multi_domain", order_attributes
      )

      order = Digicert::SSLCertificate::SSLMultiDomain.create(
        order_attributes
      )

      expect(order.id).not_to be_nil
      expect(order.requests.first.id).not_to be_nil
      expect(order.requests.first.status).to eq("pending")
    end
  end

  def order_attributes
    {
      certificate: {
        organization_units: ["Developer Operations"],
        server_platform: { id: 45 },
        profile_option: "some_ssl_profile",
        dns_names: [
          "blue.digicert.com",
          "white.digicert.com",
          "blue.white.digicert.com"
        ],

        # Required for certificate
        csr: "------ [CSR HERE] ------",
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
