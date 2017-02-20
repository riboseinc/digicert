require "digicert/base_order"

module Digicert
  module ClientCertificate
    class Premium < Digicert::BaseOrder
      private

      def certificate_type
        "client_premium_sha2"
      end

      def validate_certificate(emails:, **attributes)
        super(attributes.merge(emails: emails))
      end
    end
  end
end
