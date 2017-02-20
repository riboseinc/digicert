require "digicert/base_order"

module Digicert
  module SSLCertificate
    class SSLPlus < Digicert::BaseOrder
      private

      def certificate_type
        "ssl_plus"
      end
    end
  end
end
