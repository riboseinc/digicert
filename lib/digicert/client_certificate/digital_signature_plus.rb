require "digicert/client_certificate/base"

module Digicert
  module ClientCertificate
    class DigitalSignaturePlus < Digicert::ClientCertificate::Base
      private

      def certificate_type
        "client_digital_signature_plus"
      end
    end
  end
end
