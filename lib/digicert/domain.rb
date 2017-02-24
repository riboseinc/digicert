require "digicert/base"
require "digicert/actions/create"

module Digicert
  class Domain < Digicert::Base
    include Digicert::Actions::Create

    def activate
      Digicert::Request.new(
        :put, [resource_path, resource_id, "activate"].join("/"),
      ).parse
    end

    def deactivate
      Digicert::Request.new(
        :put, [resource_path, resource_id, "deactivate"].join("/"),
      ).parse
    end

    # The `.find` interface is just an alternvatie to instantiate
    # a new object, and please remeber this does not perform any
    # actual API Request. Use this interface whenever you need to
    # instantite an object from an existing id and then perform
    # some operation throught the objec's instnace methods, like
    # `#active` and `#deactivate`.
    #
    # If you need an actual API response then use the `.fetch`
    # API, that will perform an actual API Reqeust and will return
    # the response from the Digicer API.
    #
    # We are not going to implement this right away, but in long
    # run may be we cna add some sort to lazy evaluation on this
    # interface, but that's not for sure.
    #
    def self.find(domain_id)
      new(resource_id: domain_id)
    end

    private

    def resource_path
      "domain"
    end

    def validate_validations(attributes)
      attributes.each do |attribute|
        validate_validation(attribute)
      end
    end

    def validate_validation(type:, **attributes)
      { type: type }.merge(attributes)
    end

    def validate(name:, organization:, validations:, **attributes)
      required_attributes = {
        name: name,
        organization: organization,
        validations: validate_validations(validations)
      }

      required_attributes.merge(attributes)
    end
  end
end
