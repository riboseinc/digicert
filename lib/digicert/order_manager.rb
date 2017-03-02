require "digicert/base"

module Digicert
  class OrderManager < Digicert::Base
    include Digicert::Actions::Create

    def self.create(order_id:, **attributes)
      new(resource_id: order_id, **attributes).create
    end

    private

    def validate(attributes)
      order_attributes.merge(attributes)
    end

    def order_attributes
      {
        certificate: {
          common_name: order.certificate.common_name,
          dns_names: order.certificate.dns_names,
          csr: order.certificate.csr,
          signature_hash: order.certificate.signature_hash,
          server_platform: { id: order.certificate.server_platform.id },
        }
      }
    end

    def order
      @order ||= Digicert::Order.fetch(order_id)
    end

    # Expose the resource_id as order_id, as it sounds
    # more readable and all of it's subclasses are only
    # gonna deal with order.
    #
    alias_method :order_id, :resource_id
  end
end
