require "digicert/request"
require "digicert/actions"

module Digicert
  class Base
    def initialize(attributes = {})
      @attributes = attributes
      extract_base_attribute_ids

      extract_local_attribute_ids
    end

    private

    attr_reader :attributes, :resource_id, :query_params

    # Override this method to extract ids that are specific
    # to each of the specific sub classes, for example: if
    # you want to extract `order_id` from the attributes
    #
    # @order_id = attributes.delete(:order_id)
    #
    def extract_local_attribute_ids
    end

    def extract_base_attribute_ids
      @query_params = attributes.delete(:params)
      @resource_id = attributes.delete(:resource_id)
    end
  end
end
