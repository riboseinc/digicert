require "digicert/base"

module Digicert
  class OrderCancellation < Digicert::Base
    def create
      request_klass.new(
        :put, resource_path, **default_attributes.merge(attributes)
      ).run
    end

    def self.create(order_id:, note:, **attributes)
      new(attributes.merge(resource_id: order_id, note: note)).create
    end

    private

    def resource_path
      ["order", "certificate", resource_id, "status"].join("/")
    end

    def default_attributes
      { status: "CANCELED", send_emails: false }
    end
  end
end
