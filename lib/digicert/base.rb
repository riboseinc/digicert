require "digicert/request"
require "digicert/actions/all"
require "digicert/actions/fetch"

module Digicert
  class Base
    include Digicert::Actions::All
    include Digicert::Actions::Fetch

    def initialize(attributes = {})
      @attributes = attributes

      extract_base_attribute_ids
      extract_local_attribute_ids
    end

    private

    attr_reader :attributes, :resource_id, :query_params

    def extract_base_attribute_ids
      @query_params = attributes.delete(:params)
      @resource_id = attributes.delete(:resource_id)
    end

    def extract_local_attribute_ids
      # Implement this to extract ids that are specific
      # to each of the specific classes, for example
      #
      # @order_id = attributes.delete(:order_id)
    end

    def resources_key
      [resource_path, "s"].join
    end

    def resource_creation_path
    end
  end
end
