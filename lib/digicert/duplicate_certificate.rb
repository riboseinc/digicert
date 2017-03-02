require "digicert/base"

module Digicert
  class DuplicateCertificate < Digicert::Base
    include Digicert::Actions::All

    def self.all(order_id:, **attributes)
      new(resource_id: order_id, **attributes).all
    end

    private

    def resources_key
      "certificates"
    end

    def resource_path
      ["order", "certificate", resource_id, "duplicate"].join("/")
    end
  end
end
