require "digicert/actions/base"

module Digicert
  module Actions
    module Fetch
      extend Digicert::Actions::Base

      def fetch
        Digicert::Request.new(
          :get, [resource_path, resource_id].join("/"), params: query_params,
        ).run
      end

      module ClassMethods
        def fetch(resource_id, filter_params = {})
          new(resource_id: resource_id, params: filter_params).fetch
        end
      end
    end
  end
end
