require "spec_helper"

RSpec.describe "Order SSl EV Plus" do
  describe "ording ssl ev plus certificate", api_call: true do
    it "creates a new order fro ssl ev plus certificate" do
      product_name_id = "ssl_ev_plus"

      # Reqeust a new certificate using the order creation
      # interface by providing t`name_id` and required attributes
      #
      order_request = Digicert::Order.create(
        product_name_id, order_attributes,
      )

      # Retrieve order details using the order_request id as
      # it should contains the `certifcate`, so we then can
      # download the generated certificate
      #
      order = Digicert::Order.fetch(order_request.id)

      expect(order.product.name).to eq("EV SSL Plus")
      expect(order.certificate.common_name).to eq(common_name)
      expect(order.organization.display_name).to eq(ribose_inc.display_name)
    end
  end

  def common_name
    "ribosetest.com"
  end

  def order_attributes
    {
      validity_years: 1,
      certificate: certificate_attributes,
      organization: { id: ribose_inc.id },
    }
  end

  def ribose_inc
    @ribose_inc ||= Digicert::Organization.all.first
  end

  def certificate_attributes
    {
      common_name: common_name,
      signature_hash: "sha256",
      csr: csr_content_for_ribosetest,
      server_platform: { id: 2 }
    }
  end

  def csr_content_for_ribosetest
    @csr_content ||= Digicert::CSRGenerator.generate(
      common_name: common_name, organization: ribose_inc,
    )
  end
end
