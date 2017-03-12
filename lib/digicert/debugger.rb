module Digicert
  class Debugger
    def initialize(request:, response:)
      @request = request
      @response = response
    end

    def debug
      puts "[API Reqeust Begin]".center(50, "=")
      puts api_request_details
      puts api_response_details
      puts "[API Reqeust End]".center(50, "=")
    end

    private

    attr_reader :request, :response

    def api_request_details
      uri = ["[URI]", request.method, request.uri].join(" ")
      headers = "[Headers] " + request.to_hash.to_s
      body = "[Request Body] " + request.body.to_json if request.body

      [uri, headers, body].join("\n")
    end

    def api_response_details
      response_object = "[Response] " + response.inspect
      body = "[Response Body] " + response.body if response.body

      [response_object, body].join("\n")
    end
  end
end
