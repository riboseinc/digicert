require "digicert/order_manager"

module Digicert
  class OrderReissuer < Digicert::OrderManager
    private

    def resource_creation_path
      ["order", "certificate", order_id, "reissue"].join("/")
    end
  end
end
