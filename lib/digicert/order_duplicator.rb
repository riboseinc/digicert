require "digicert/order_manager"

module Digicert
  class OrderDuplicator < Digicert::OrderManager
    private

    def resource_creation_path
      ["order", "certificate", order_id, "duplicate"].join("/")
    end
  end
end
