require "digicert/order/base"

module Digicert
  module Order
    class SSLWildcard < Digicert::Order::Base
      private

      def certificate_type
        "ssl_wildcard"
      end
    end
  end
end
