require "digicert/base"

module Digicert
  class CertificateRequest < Digicert::Base

    def update(request_id, attributes)
      Digicert::Request.new(
        :put, [resource_path, request_id, "status"].join("/"), attributes,
      ).run
    end

    private

    def resource_path
      "request"
    end
  end
end
