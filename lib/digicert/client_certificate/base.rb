require "digicert/base_order"

module Digicert
  module ClientCertificate
    class Base < Digicert::BaseOrder
      private

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
