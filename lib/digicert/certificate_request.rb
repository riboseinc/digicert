require "digicert/base"

module Digicert
  class CertificateRequest < Digicert::Base

    def update
      Digicert::Request.new(
        :put, update_status_path, attributes,
      ).parse
    end

    def self.update(resource_id, attributes)
      new(resource_id: resource_id, **attributes).update
    end

    private

    def resource_path
      "request"
    end

    def update_status_path
      [resource_path, resource_id, "status"].join("/")
    end
  end
end
