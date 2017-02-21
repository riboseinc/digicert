require "digicert/request"
require "digicert/actions/fetch"

module Digicert
  class Base
    include Digicert::Actions::Fetch

    def initialize(resource_id: nil, **attributes)
      @resource_id = resource_id
      @attributes = attributes
    end

    def all
      response = Digicert::Request.new(:get, resource_path).run
      response[resources_key]
    end

    def self.all
      new.all
    end

    private

    attr_reader :resource_id, :attributes

    def resources_key
      [resource_path, "s"].join
    end
  end
end
