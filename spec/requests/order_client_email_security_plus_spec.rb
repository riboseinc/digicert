require "spec_helper"

RSpec.describe "Order client email security plus" do
  describe "ordering client email security plus", api_call: true do
    it "creates a new order for client email security plus" do
      product_name_id = "email_security_plus"

      # Reqeust a new email security plus using the order creation
      # interface with `product_name_id` and required attributes
      #
      order_request = Digicert::Order.create(
        product_name_id, order_attributes
      )

      puts order_request
    end
  end

  def ribose_inc
    @ribose_inc ||= Digicert::Organization.all.first
  end

  def order_attributes
    {
      validity_years: 3,
      certificate: certificate_attributes,
      organization: { id: ribose_inc.id },
    }
  end

  def certificate_attributes
    {
      common_name: "John Doe",
      signature_hash: "sha256",
      emails: ["johndoe@ribosetest.com"],
    }
  end
end
