require "digicert/base_order"

module Digicert
  module SSLCertificate
    class SSLEVPlus < Digicert::BaseOrder
      private

      def certificate_type
        "ssl_ev_plus"
      end
    end
  end
end
