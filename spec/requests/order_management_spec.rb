require "spec_helper"

RSpec.describe "Order Management" do
  describe "retrieving a certificate order", api_call: true do
    it "retrieves the details for a specific certificate order" do
      order = Digicert::Order.fetch(order_id)

      expect(order.product_name_id).to eq("ssl_plus")
      expect(order.certificate.common_name).to eq("ribosetest.com")
      expect(order.organization.display_name).to eq("Ribose Inc.")
    end
  end

  def order_id
    @order_id ||= orders.first.id
  end

  def orders
    # We are intentionally making this API call to ensure
    # the `Order.all` interface is working as it should have.
    #
    @orders ||= Digicert::Order.all
  end
end
