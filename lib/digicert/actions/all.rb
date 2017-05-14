require "digicert/actions/base"

module Digicert
  module Actions
    module All
      extend Digicert::Actions::Base

      def all
        response = Digicert::Request.new(
          :get, resource_path, params: query_params
        ).parse

        response[resources_key]
      end

      def resources_key
        [resource_path, "s"].join
      end

      module ClassMethods
        def all(query_params = {})
          new(params: query_params).all
        end

        def filter(filter_params = {})
          new(params: { filters: filter_params }).all
        end
      end
    end
  end
end
