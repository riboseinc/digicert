require "digicert/actions/base"

module Digicert
  module Actions
    module Fetch
      extend Digicert::Actions::Base

      def fetch
        Digicert::Request.new(
          :get, [resource_path, resource_id].join("/"),
        ).run
      end

      module ClassMethods
        def fetch(resource_id)
          new(resource_id: resource_id).fetch
        end
      end
    end
  end
end
