require "digicert/ssl_certificate/base"

module Digicert
  module SSLCertificate
    class SSLEVPlus < Digicert::SSLCertificate::Base
      private

      def certificate_type
        "ssl_ev_plus"
      end
    end
  end
end
