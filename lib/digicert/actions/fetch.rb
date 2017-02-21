require "digicert/request"

module Digicert
  module Actions
    module Fetch
      def fetch
        Digicert::Request.new(
          :get, [resource_path, resource_id].join("/"),
        ).run
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def fetch(resource_id)
          new(resource_id: resource_id).fetch
        end
      end
    end
  end
end
