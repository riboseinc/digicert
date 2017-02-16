require "uri"
require "json"
require "net/http"
require "digicert/response"

module Digicert
  class Request
    def initialize(http_method, end_point, attributes = {})
      @end_point = end_point
      @http_method = http_method
      @attributes = attributes
    end

    def run
      Response.new(send_http_request).parse
    end

    private

    attr_reader :attributes

    def send_http_request
      Net::HTTP.start(*net_http_options) do |http|
        request = Net::HTTP::Get.new(uri)
        set_request_headers!(request)
        set_request_body!(request)
        http.request(request)
      end
    end

    def net_http_options
      [uri.host, uri.port, use_ssl: true]
    end

    def uri
      URI::HTTPS.build(
        host: Digicert.configuration.api_host,
        path: digicert_api_path_with_base,
      )
    end

    def set_request_body!(request)
      unless attributes.empty?
        request.body = attributes.to_json
      end
    end

    def set_request_headers!(request)
      request.initialize_http_header("Content-Type" => "application/json")
      request.initialize_http_header(
        "X-DC-DEVKEY" => Digicert.configuration.api_key,
      )
    end

    def digicert_api_path_with_base
      ["", Digicert.configuration.base_path, @end_point].join("/").squeeze("/")
    end
  end
end
