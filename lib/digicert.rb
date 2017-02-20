# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

require 'curb'
require 'json'
require 'pp'

require "digicert/config"
require "digicert/product"
require "digicert/certificate_request"
require "digicert/ssl_certificate"
# require "digicert/order/ssl_plus"
# require "digicert/order/ssl_wildcard"
# require "digicert/order/ssl_ev_plus"
require "digicert/order/client_premium"
require "digicert/order/email_security_plus"
require "digicert/order/digital_signature_plus"
require "digicert/certificate_order"
require "digicert/organization"

module Digicert

  class << self

    def env_api_key
      ENV["DIGICERT_API_KEY"]
    end

    def client(key = env_api_key)
      @client ||= Digicert::Client.new(key)
    end

    # ==>> only for testing below
    #
    def list_orders
      Digicert::Order.list
    end

    def env_order_id
      ENV["DIGICERT_TEST_ORDER_ID"]
    end

    def fetch_order
      Digicert::Order.fetch_by_id(env_order_id)
    end

  end
end


require 'digicert/client'
require 'digicert/endpoint'
require 'digicert/order'
require 'digicert/certificate'


__END__

