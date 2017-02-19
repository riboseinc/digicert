require "digicert/base"

module Digicert
  class CertificateOrder < Digicert::Base
    private

    def resource_path
      "order/certificate/"
    end
  end
end
