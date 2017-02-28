require "digicert/order_manager"
require "digicert/actions/all"

module Digicert
  class OrderDuplication < Digicert::OrderManager
    include Digicert::Actions::All

    def self.all(order_id:)
      new(order_id: order_id).all
    end

    private

    def resources_key
      "certificates"
    end

    def resource_path
      ["order","certificate", order_id, "duplicate"].join("/")
    end
  end
end
