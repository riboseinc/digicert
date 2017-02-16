require "digicert/request"

module Digicert
  class Base
    def all
      response = Digicert::Request.new(:get, resource_path).run
      response[resources_key]
    end

    def fetch(name_id)
      Digicert::Request.new(:get, [resource_path, name_id].join("/")).run
    end

    def self.method_missing(method_name, *arguments, &block)
      if new.respond_to?(method_name, include_private: false)
        new.send(method_name, *arguments, &block)
      else
        super
      end
    end

    private

    def resources_key
      [resource_path, "s"].join
    end
  end
end
