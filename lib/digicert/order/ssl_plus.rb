require "digicert/order/base"

module Digicert
  module Order
    class SSLPlus < Digicert::Order::Base
      private

      def certificate_type
        "ssl_plus"
      end
    end
  end
end
