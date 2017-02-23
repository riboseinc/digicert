require "digicert/actions/base"

module Digicert
  module Actions
    module All
      extend Digicert::Actions::Base

      def all
        response = Digicert::Request.new(
          :get, resource_path, params: query_params,
        ).run

        response[resources_key]
      end

      module ClassMethods
        def all(filter_params = {})
          new(params: filter_params).all
        end
      end
    end
  end
end
