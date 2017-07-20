require "spec_helper"

RSpec.describe Digicert::OrderDuplicator do
  describe ".create" do
    it "creates a duplicate of an existing order" do
      stub_digicert_order_fetch_api(order_id)

      stub_digicert_order_duplicate_api(order_id, certificate_attributes)
      order = Digicert::OrderDuplicator.create(order_id: order_id)

      expect(order.id).not_to be_nil
      expect(order.requests.first.id).not_to be_nil
    end
  end

  def order_id
    123_456_789
  end

  def certificate_attributes
    {
      common_name: order.certificate.common_name,
      dns_names: order.certificate.dns_names,
      csr: order.certificate.csr,
      signature_hash: order.certificate.signature_hash,
      server_platform: { id: order.certificate.server_platform.id },
    }
  end

  def order
    @order ||= Digicert::Order.fetch(order_id)
  end
end
