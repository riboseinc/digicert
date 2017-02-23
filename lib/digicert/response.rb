require "json"
require 'ostruct'

module Digicert
  class Response
    def initialize(response)
      @response = response
    end

    def parse
      parse_response || response
    end

    private

    attr_reader :response

    def parse_response
      if response.body
        JSON.parse(response.body, object_class: ResponseObject)
      end
    end
  end

  class ResponseObject < OpenStruct;end
end
