require "digicert/request"

module Digicert
  class Base
    def initialize(resource_id: nil, **attributes)
      @resource_id = resource_id
      @attributes = attributes
    end

    def all
      response = Digicert::Request.new(:get, resource_path).run
      response[resources_key]
    end

    def fetch
      Digicert::Request.new(
        :get, [resource_path, @resource_id].join("/"),
      ).run
    end

    def self.all
      new.all
    end

    def self.fetch(resource_id)
      new(resource_id: resource_id).fetch
    end

    private

    attr_reader :resource_id, :attributes

    def resources_key
      [resource_path, "s"].join
    end
  end
end
