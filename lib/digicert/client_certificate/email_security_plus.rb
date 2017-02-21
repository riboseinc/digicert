require "digicert/client_certificate/base"

module Digicert
  module ClientCertificate
    class EmailSecurityPlus < Digicert::ClientCertificate::Base
      private

      def certificate_type
        "client_email_security_plus"
      end
    end
  end
end
