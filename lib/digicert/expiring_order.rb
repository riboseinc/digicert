require "digicert/base"

module Digicert
  class ExpiringOrder < Digicert::Base
    include Digicert::Actions::All

    def self.all(container_id:, **filter_params)
      new(resource_id: container_id, params: filter_params).all
    end

    private

    def resources_key
      "expiring_orders"
    end

    def resource_path
      ["report", "order", resource_id, "expiring"].join("/")
    end
  end
end
