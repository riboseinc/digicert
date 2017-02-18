require "digicert/order/base"

module Digicert
  module Order
    class EmailSecurityPlus < Digicert::Order::Base
      private

      def certificate_type
        "client_email_security_plus"
      end

      def validate_certificate(common_name:, signature_hash:, emails:, **attrs)
        attrs.merge(
          emails: emails,
          common_name: common_name,
          signature_hash: signature_hash,
        )
      end
    end
  end
end
