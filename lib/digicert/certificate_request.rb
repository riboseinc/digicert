require "digicert/request"

module Digicert
  class CertificateRequest
    def self.all
      response = Digicert::Request.new(:get, "request").run
      response.requests
    end
  end
end
