require "spec_helper"

RSpec.describe Digicert::OrderCancellation do
  describe ".create" do
    it "cancels an existing order" do
      order_id = 123_456_789

      stub_digicert_order_cancellation_api(order_id, cancellation_attributes)
      order_cancellation = Digicert::OrderCancellation.create(
        order_id: order_id, **cancellation_attributes,
      )

      expect(order_cancellation.code.to_i).to eq(204)
    end
  end

  def cancellation_attributes
    {
      status: "CANCELED",
      send_emails: true,
      note: "This is a cancellation note",
    }
  end
end
