# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert
  class Endpoint

    API_BASE = "https://www.digicert.com/services/v2"
    API_ORDER_CLIENT_PREMIUM = "#{API_BASE}/order/certificate/client_premium_sha2"
    API_ORDER_VIEW = "/order/certificate/ORDERID"
    API_CERTIFICATE_DOWNLOAD = "/order/certificate/ORDERID"
    API_ORDER_CLIENT_PREMIUM = "/order/certificate/client_premium_sha2"

    def new(url)
      URI.encode(URI.decode(url))
    end

    def order_client_certificate
      "#{API_BASE}"
    end

    def view_order(order_id)
      "#{base}/order/certificate/#{order_id}"
    end

    def certificate_download(certificate_id)
      "#{base}/order/certificate/client_premium_sha2"
    end
  end
end
