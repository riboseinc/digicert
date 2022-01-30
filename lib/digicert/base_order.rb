require "digicert/base"

module Digicert
  class BaseOrder < Digicert::Base
    include Digicert::Actions::Create

    private

    def validate(certificate:, organization:, validity_years:, **attributes)
      required_attributes = {
        certificate: validate_certificate(**certificate),
        organization: validate_organization(**organization),
        validity_years: validity_years,
      }

      required_attributes.merge(attributes)
    end

    def resource_path
      "order/certificate"
    end

    def resource_creation_path
      [resource_path, certificate_type].join("/")
    end

    def validate_organization(id:)
      { id: id }
    end

    def validate_certificate(common_name:, csr:, signature_hash:, **attrs)
      attrs.merge(
        csr: csr,
        common_name: common_name,
        signature_hash: signature_hash,
      )
    end
  end
end
