require "json"
require 'ostruct'

module Digicert
  class Response
    def initialize(response)
      @response = response
    end

    def parse
      JSON.parse(@response.body || "{}", object_class: ResponseObject)
    end
  end

  class ResponseObject < OpenStruct;end
end
