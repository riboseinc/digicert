require "uri"
require "json"
require "net/http"
require "digicert/response"
require "digicert/errors"

module Digicert
  class Request
    def initialize(http_method, end_point, params: {}, **attributes)
      @end_point = end_point
      @http_method = http_method
      @attributes = attributes
      @query_params = params
    end

    def run
      valid_response || raise_response_error
    end

    def parse
      Digicert::Response.new(run).parse
    end

    private

    attr_reader :attributes

    def valid_response
      if valid_response?
        response
      end
    end

    def valid_response?
      response.is_a?(Net::HTTPSuccess)
    end

    def response
      @response ||= send_http_request
    rescue *server_errors => error
      @response ||= error
    end

    def send_http_request
      Net::HTTP.start(*net_http_options) do |http|
        request = constanize_net_http_class.new(uri)
        set_request_headers!(request)
        set_request_body!(request)
        http.request(request)
      end
    end

    def raise_response_error
      raise response_error, error_message
    end

    def net_http_options
      [uri.host, uri.port, use_ssl: true]
    end

    def uri
      URI::HTTPS.build(
        host: Digicert.configuration.api_host,
        path: digicert_api_path_with_base,
        query: build_query_params,
      )
    end

    def constanize_net_http_class
      Object.const_get("Net::HTTP::#{@http_method.capitalize}")
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

    def build_query_params
      if @query_params
        URI.encode_www_form(@query_params)
      end
    end

    def digicert_api_path_with_base
      ["", Digicert.configuration.base_path, @end_point].join("/").squeeze("/")
    end

    def response_error
      Digicert::Errors.error_klass_for(response)
    end

    def server_errors
      Digicert::Errors.server_errors
    end

    # This is only for the development purpose, later we can
    # add an option to turn on the debug mode if necessary.
    #
    def error_message
      response.body
    end
  end
end
