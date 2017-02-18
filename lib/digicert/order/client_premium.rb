require "digicert/order/base"

module Digicert
  module Order
    class ClientPremium < Digicert::Order::Base
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
