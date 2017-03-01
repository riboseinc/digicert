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

    # The `.find` interface is just an alternvatie to instantiate
    # a new object, and please remeber this does not perform any
    # actual API Request. Use this interface whenever you need to
    # instantite an object from an existing id and then perform
    # some operation throught the objec's instnace methods, like
    # `#active`, `#reissue` and etc
    #
    # If you need an actual API response then use the `.fetch`
    # API, that will perform an actual API Reqeust and will return
    # the response from the Digicer API.
    #
    # We are not going to implement this right away, but in long
    # run may be we cna add some sort to lazy evaluation on this
    # interface, but that's not for sure.
    #
    def self.find(resource_id)
      new(resource_id: resource_id)
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
