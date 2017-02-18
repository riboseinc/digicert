require "digicert/base"

module Digicert
  module Order
    class SSLWildcard < Digicert::Base
      def create(certificate:, organization:, validity_years:, **attributes)
        required_attributes = {
          certificate: validate_certificate(certificate),
          organization: validate_organization(organization),
          validity_years: validity_years,
        }

        Digicert::Request.new(
          :post, resource_path, required_attributes.merge(attributes),
        ).run
      end

      def self.create(order_attributes)
        new.create(order_attributes)
      end

      private

      def resource_path
        "order/certificate/ssl_wildcard"
      end

      def validate_organization(id:)
        { id: id }
      end

      def validate_certificate(common_name:, csr:, signature_hash:, **attrs)
        attrs.merge(
          csr: csr, common_name: common_name, signature_hash: signature_hash,
        )
      end
    end
  end
end
