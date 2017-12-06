require "digicert/client_certificate/base"

module Digicert
  module ClientCertificate
    class PrivatePremium < Digicert::ClientCertificate::Base
      private

      def certificate_type
        'private_client_premium'
      end
    end
  end
end
