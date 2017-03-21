require "digicert/base"
require "digicert/findable"

module Digicert
  class Domain < Digicert::Base
    extend Digicert::Findable

    include Digicert::Actions::All
    include Digicert::Actions::Fetch
    include Digicert::Actions::Create

    def activate
      request_klass.new(
        :put, [resource_path, resource_id, "activate"].join("/"),
      ).parse
    end

    def deactivate
      request_klass.new(
        :put, [resource_path, resource_id, "deactivate"].join("/"),
      ).parse
    end

    private

    def resource_path
      "domain"
    end

    def validate_validations(attributes)
      attributes.map do |attribute|
        validate_validation(attribute)
      end
    end

    # Validate validation
    #
    # We need to provide a valid type of valitations when creating a new domain,
    # but the most important thing about the types are it has to be in lowercase
    # format, otherwise Digicert won't accept it a valid type. So let's ensure
    # we are always providig the type in correct format.
    #
    # Ref: https://www.digicert.com/services/v2/documentation/appendix-validation-types
    #
    def validate_validation(type:, **attributes)
      { type: type.downcase }.merge(attributes)
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
