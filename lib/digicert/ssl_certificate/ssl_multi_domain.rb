require "digicert/ssl_certificate/base"

module Digicert
  module SSLCertificate
    class SSLMultiDomain < Digicert::SSLCertificate::Base
      private

      def certificate_type
        "ssl_multi_domain"
      end
    end
  end
end
