require "spec_helper"

RSpec.describe Digicert::OrderReissuer do
  describe ".create" do
    context "without custom attributes" do
      it "reissues with existing order attributes" do
        stub_digicert_order_fetch_api(order_id)
        stub_digicert_order_reissue_api(order_id, certificate_attributes)

        order = Digicert::OrderReissuer.create(order_id: order_id)

        expect(order.id).not_to be_nil
        expect(order.requests.first.id).not_to be_nil
      end
    end

    context "with custom attributes" do
      it "reissues with merging the existing and custom attributes" do
        stub_digicert_order_fetch_api(order_id)
        stub_digicert_order_reissue_api(order_id, certificate_attributes)

        order = Digicert::OrderReissuer.create(
          order_id: order_id, **certificate_attributes
        )

        expect(order.id).not_to be_nil
        expect(order.requests.first.id).not_to be_nil
      end
    end
  end

  def order_id
    123_456_789
  end

  def order
    @order ||= Digicert::Order.fetch(order_id)
  end

  def certificate_attributes
    {
      common_name: order.certificate.common_name,
      dns_names: order.certificate.dns_names,
      csr: order.certificate.csr,
      signature_hash: order.certificate.signature_hash,
      # server_platform: { id: order.certificate.server_platform.id },
    }
  end

  def new_attributes
    @new_attributes ||= certificate_attributes.merge(signature_hash: "sha512")
  end
end
