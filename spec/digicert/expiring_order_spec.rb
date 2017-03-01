require "spec_helper"

RSpec.describe Digicert::ExpiringOrder do
  describe ".all" do
    it "retrieves all the expiring orders" do
      container_id = 123_456_789

      stub_digicert_order_expiring_api(container_id)
      expiring_orders = Digicert::ExpiringOrder.all(container_id: container_id)

      expect(expiring_orders.count).to eq(4)
      expect(expiring_orders.first.order_count).to eq(10)
      expect(expiring_orders.first.days_expiring).to eq(90)
    end
  end
end
