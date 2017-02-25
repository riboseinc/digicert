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
