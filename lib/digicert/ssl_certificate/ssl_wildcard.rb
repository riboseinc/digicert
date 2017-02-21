require "digicert/ssl_certificate/base"

module Digicert
  module SSLCertificate
    class SSLWildcard < Digicert::SSLCertificate::Base
      private

      def certificate_type
        "ssl_wildcard"
      end
    end
  end
end
