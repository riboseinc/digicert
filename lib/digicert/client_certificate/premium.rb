require "digicert/client_certificate/base"

module Digicert
  module ClientCertificate
    class Premium < Digicert::ClientCertificate::Base
      private

      def certificate_type
        "client_premium_sha2"
      end

      def validate_certificate(csr:, **attributes)
        super(attributes.merge(csr: csr))
      end
    end
  end
end
