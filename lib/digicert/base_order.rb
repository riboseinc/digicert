require "digicert/base"

module Digicert
  class BaseOrder < Digicert::Base
    def create(certificate:, organization:, validity_years:, **attributes)
      required_attributes = {
        certificate: validate_certificate(certificate),
        organization: validate_organization(organization),
        validity_years: validity_years,
      }

      create_order(required_attributes, attributes)
    end

    def self.create(order_attributes)
      new.create(order_attributes)
    end

    private

    def create_order(required_attrs, additional_attrs)
      Digicert::Request.new(
        :post, order_creation_path, required_attrs.merge(additional_attrs),
      ).run
    end

    def order_creation_path
      [resource_path, certificate_type].join("/")
    end

    def resource_path
      "order/certificate"
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
