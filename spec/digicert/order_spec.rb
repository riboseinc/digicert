require "spec_helper"

RSpec.describe Digicert::Order do
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

  describe ".create" do
    it "sends create message to certificate klass" do
      name_id = "ssl_plus"
      allow(Digicert::SSLCertificate::SSLPlus).to receive(:create)

      Digicert::Order.create(name_id, order_attributes)

      expect(
        Digicert::SSLCertificate::SSLPlus,
      ).to have_received(:create).with(order_attributes)
    end
  end

  describe "#email_validations" do
    it "sends all message to EmailValidation" do
      order_id = 123_456_789
      order = Digicert::Order.find(order_id)
      allow(Digicert::EmailValidation).to receive(:all)

      order.email_validations

      expect(
        Digicert::EmailValidation,
      ).to have_received(:all).with(order_id: order_id)
    end
  end

  describe "#reissue" do
    it "sends Reissuer a create message" do
      order_id = 123_456_789
      order = Digicert::Order.find(order_id)
      allow(Digicert::OrderReissuer).to receive(:create)

      order.reissue

      expect(
        Digicert::OrderReissuer,
      ).to have_received(:create).with(order_id: order_id)
    end
  end

  describe "#duplicate" do
    it "sends the duplicator a create message" do
      order_id = 123_456_789
      order = Digicert::Order.find(order_id)
      allow(Digicert::OrderDuplicator).to receive(:create)

      order.duplicate

      expect(
        Digicert::OrderDuplicator,
      ).to have_received(:create).with(order_id: order_id)
    end
  end

  describe "#duplicate_certificates" do
    it "sends all message to order duplication" do
      order_id = 123_456_789
      order = Digicert::Order.find(order_id)
      allow(Digicert::DuplicateCertificate).to receive(:all)

      order.duplicate_certificates

      expect(
        Digicert::DuplicateCertificate,
      ).to have_received(:all).with(order_id: order_id)
    end
  end

  describe "#cancel" do
    it "sends the create methods to order cancellation" do
      order_id = 123_456_789
      note = "This is the cancellation note"

      order = Digicert::Order.find(order_id)
      allow(Digicert::OrderCancellation).to receive(:create)

      order.cancel(note: note)

      expect(
        Digicert::OrderCancellation,
      ).to have_received(:create).with(order_id: order_id, note: note)
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
