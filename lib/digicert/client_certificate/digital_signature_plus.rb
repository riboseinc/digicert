require "digicert/base_order"

module Digicert
  module ClientCertificate
    class DigitalSignaturePlus < Digicert::BaseOrder
      private

      def certificate_type
        "client_digital_signature_plus"
      end

      def validate_certificate(emails:, **attributes)
        super(attributes.merge(emails: emails))
      end
    end
  end
end
