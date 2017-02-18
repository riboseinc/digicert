require "digicert/order/base"

module Digicert
  module Order
    class SSLEVPlus < Digicert::Order::Base
      private

      def certificate_type
        "ssl_ev_plus"
      end
    end
  end
end
