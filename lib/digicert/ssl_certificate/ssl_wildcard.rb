require "digicert/base_order"

module Digicert
  module SSLCertificate
    class SSLWildcard < Digicert::BaseOrder
      private

      def certificate_type
        "ssl_wildcard"
      end
    end
  end
end
