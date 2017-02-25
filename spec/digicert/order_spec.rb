require "spec_helper"

RSpec.describe Digicert::Order do
  describe ".create" do
    it "creates a new order" do
      name_id = "ssl_plus"

      stub_digicert_order_create_api(name_id, order_attributes)
      order = Digicert::Order.create(name_id, order_attributes)

      expect(order.id).not_to be_nil
      expect(order.requests.first.id).not_to be_nil
      expect(order.requests.first.status).not_to be_nil
    end
  end

  describe ".fetch" do
    it "retrieves a specific certificate order" do
      order_id = 123_456_789

      stub_digicert_order_fetch_api(order_id)
      order = Digicert::Order.fetch(order_id)

      expect(order.id).not_to be_nil
      expect(order.status).to eq("approved")
      expect(order.certificate.common_name).to eq("digicert.com")
    end
  end

  describe ".all" do
    it "retrieves the list of all certificate orders" do
      stub_digicert_order_list_api
      orders = Digicert::Order.all

      expect(orders.first.id).not_to be_nil
      expect(orders.first.status).to eq("issued")
      expect(orders.first.certificate.common_name).to eq("digicert.com")
    end
  end

  describe "#email_validations" do
    it "retrieves list of emails with validation status" do
      order_id = 123_456_789
      order = Digicert::Order.find(order_id)

      stub_digicert_email_validations_api(order_id)
      email_validations = order.email_validations

      expect(email_validations.first.status).to eq("validated")
      expect(email_validations.first.email).to eq("email@example.com")
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
        common_name: "digicert.com",
        signature_hash: "sha256",
      },
      organization: { id: 117483 },
      validity_years: 3,
      custom_expiration_date: "2017-05-18",
      comments: "Comments for the the approver",
      disable_renewal_notifications: false,
      renewal_of_order_id: 314152,
      payment_method: "balance",
    }
  end
end
