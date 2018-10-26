require "digicert/ssl_certificate/base"

module Digicert
  module SSLCertificate
    class SSLEVMultiDomain < Digicert::SSLCertificate::Base
      private

      def certificate_type
        "ssl_ev_multi_domain"
      end
    end
  end
end
