require "digicert/request"

module Digicert
  class CertificateRequest
    def self.all
      response = Digicert::Request.new(:get, "request").run
      response.requests
    end

    def self.fetch(request_id)
      Digicert::Request.new(:get, ["request", request_id].join("/")).run
    end

    def self.update(request_id, attributes)
      Digicert::Request.new(
        :put, ["request", request_id, "status"].join("/"), attributes,
      ).run
    end
  end
end
