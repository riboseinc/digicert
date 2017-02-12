# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert
  module Order
    class << self
      # https://www.digicert.com/services/v2/order/certificate

      # TODO: support pagination according to API
      def list
        orders = Digicert.client.perform("https://www.digicert.com/services/v2/order/certificate") do |curl|
          curl.headers["Accept"] = "application/json"
          curl.verbose = true
        end

        orders["orders"].map do |o|
          instantiate_by_type o
        end
      end

      def fetch_by_id(order_id)
        order = Digicert.client.perform("https://www.digicert.com/services/v2/order/certificate/#{order_id}") do |curl|
          curl.headers["Accept"] = "application/json"
          curl.verbose = true
        end

        pp order

        instantiate_by_type order
      end

      def instantiate_by_type order_hash

        puts 'instantiate_by_type'
        pp order_hash

        case order_hash["product"]["name_id"]
        when "ssl_plus",
          "ssl_wildcard"
          Ssl.new order_hash

        when "ssl_ev_plus"
          EvSsl.new order_hash

        when "client_premium",
          "client_email_security_plus",
          "client_digital_signature_plus"

          EvSsl.new order_hash

        when "private_ssl_certificate"
        end

      end

    end

  end
end

require 'digicert/order/base'
require 'digicert/order/ssl'
require 'digicert/order/ev_ssl'
require 'digicert/order/private'

__END__

