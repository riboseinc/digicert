require "digicert/actions/all"

module Digicert
  class DuplicateCertificate
    include Digicert::Actions::All

    def initialize(order_id:, params: {})
      @order_id = order_id
      @query_params = params
    end

    def self.all(order_id:, **attributes)
      new(order_id: order_id, **attributes).all
    end

    private

    attr_reader :order_id, :query_params

    def resources_key
      "certificates"
    end

    def resource_path
      ["order", "certificate", order_id, "duplicate"].join("/")
    end
  end
end
