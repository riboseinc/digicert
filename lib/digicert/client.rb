# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert
  class Client
    attr_accessor :api_key

    def initialize(key)
      if key.nil? || key.empty?
        raise ArgumentError.new "Digicert API key not provided, unable to create client."
      end

      @api_key = key
      self
    end

    def perform(url, format = :json)
      c = Curl::Easy.new(url)
      c.headers["X-DC-DEVKEY"] = @api_key
      yield c
      c.perform
      jsonify_response(c.body_str, format)
    end

    def post(url, content, format = :json)
      c = Curl::Easy.new(url)
      c.headers["X-DC-DEVKEY"] = @api_key
      c.headers['Accept'] = 'application/json'
      c.headers['Content-Type'] = 'application/json'
      yield c
      c.http_post(content)
      jsonify_response(c.body_str, format)
    end

    def jsonify_response(body, format)
      return JSON.parse(body) if format == :json
      body
    end

  end
end
