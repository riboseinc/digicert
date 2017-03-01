module Digicert
  class OrderCancellation
    def initialize(order_id:, **attributes)
      @order_id = order_id
      @attributes = attributes
    end

    def create
      Digicert::Request.new(
        :put, resource_path, default_attributes.merge(attributes),
      ).run
    end

    def self.create(order_id:, note:, **attributes)
      new(attributes.merge(order_id: order_id, note: note)).create
    end

    private

    attr_reader :order_id, :attributes

    def resource_path
      ["order", "certificate", order_id, "status"].join("/")
    end

    def default_attributes
      { status: "CANCELED", send_emails: false }
    end
  end
end
