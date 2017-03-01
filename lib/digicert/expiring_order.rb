require "digicert/actions/base"

module Digicert
  class ExpiringOrder
    include Digicert::Actions::All

    def initialize(container_id:, params: {})
      @query_params = params
      @container_id = container_id
    end

    def self.all(container_id:, **filter_params)
      new(container_id: container_id, params: filter_params).all
    end

    private

    attr_reader :container_id, :query_params

    def resources_key
      "expiring_orders"
    end

    def resource_path
      ["report", "order", container_id, "expiring"].join("/")
    end
  end
end
