require "spec_helper"

RSpec.describe Digicert::OrderReissuer do
  describe ".create" do
    it "reissue an existing order" do
      stub_digicert_order_fetch_api(order_id)

      stub_digicert_order_reissue_api(order_id, order_attributes)
      order = Digicert::OrderReissuer.create(order_id: order_id)

      expect(order.id).not_to be_nil
      expect(order.requests.first.id).not_to be_nil
    end
  end

  def order_id
    123_456_789
  end

  def order
    @order ||= Digicert::Order.fetch(order_id)
  end

  def order_attributes
    {
      certificate: {
        common_name: order.certificate.common_name,
        dns_names: order.certificate.dns_names,
        csr: order.certificate.csr,
        signature_hash: order.certificate.signature_hash,
        server_platform: { id: order.certificate.server_platform.id },
      },
    }
  end
end
