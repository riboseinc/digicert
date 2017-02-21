require "digicert/ssl_certificate/base"

module Digicert
  module SSLCertificate
    class SSLPlus < Digicert::SSLCertificate::Base
      private

      def certificate_type
        "ssl_plus"
      end
    end
  end
end
