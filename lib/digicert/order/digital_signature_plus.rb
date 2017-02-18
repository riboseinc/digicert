require "digicert/order/base"

module Digicert
  module Order
    class DigitalSignaturePlus < Digicert::Order::Base
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
