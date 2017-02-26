require "digicert/actions/create"

module Digicert
  class OrderManager
    include Digicert::Actions::Create

    def initialize(order_id:, **attributes)
      @order_id = order_id
      @attributes = attributes
    end

    private

    attr_reader :order_id, :attributes

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
  end
end
