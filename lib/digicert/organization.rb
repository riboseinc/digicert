require "digicert/base"

module Digicert
  class Organization < Digicert::Base
    include Digicert::Actions::All
    include Digicert::Actions::Fetch
    include Digicert::Actions::Create

    private

    def resource_path
      "organization"
    end

    def validate(name:, address:, zip:, city:, state:, country:,
                 telephone:, container:, organization_contact:, **attributes)
      required_attributes = {
        name: name,
        address: address,
        zip: zip,
        city: city,
        state: state,
        country: country,
        telephone: telephone,
        container: container,
        organization_contact: validate_contact(**organization_contact),
      }

      required_attributes.merge(attributes)
    end

    def validate_contact(first_name:, last_name:, email:, telephone:, **attrs)
      required_attributes = {
        first_name: first_name,
        last_name: last_name,
        email: email,
        telephone: telephone,
      }

      required_attributes.merge(attrs)
    end
  end
end
