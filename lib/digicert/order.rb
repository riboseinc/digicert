# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

require "digicert/base"
require "digicert/ssl_certificate/ssl_plus"
require "digicert/ssl_certificate/ssl_ev_plus"
require "digicert/ssl_certificate/ssl_wildcard"

require "digicert/client_certificate/premium"
require "digicert/client_certificate/email_security_plus"
require "digicert/client_certificate/digital_signature_plus"

module Digicert
  class Order < Digicert::Base
    def initialize(attributes = {})
      @name_id = attributes.delete(:name_id)
      super
    end

    def create
      certificate_klass.create(attributes)
    end

    def self.create(name_id, attributes)
      new(name_id: name_id, **attributes).create
    end

    def reissue
      Digicert::OrderReissuer.create(order_id: resource_id)
    end

    def duplicate
      Digicert::OrderDuplication.create(order_id: resource_id)
    end

    def duplicate_certificates
      Digicert::OrderDuplication.all(order_id: resource_id)
    end

    def email_validations
      Digicert::EmailValidation.all(order_id: resource_id)
    end

    private

    def resource_path
      "order/certificate"
    end

    def resources_key
      "orders"
    end

    def certificate_klass
      certificate_klass_hash[@name_id.to_sym] ||
        Digicert::SSLCertificate::SSLPlus
    end

    def certificate_klass_hash
      {
        ssl_plus: Digicert::SSLCertificate::SSLPlus,
        ssl_wildcard: Digicert::SSLCertificate::SSLWildcard,
        ssl_ev_plus: Digicert::SSLCertificate::SSLEVPlus,
        client_premium: Digicert::ClientCertificate::Premium,
        email_security_plus: Digicert::ClientCertificate::EmailSecurityPlus,
        digital_signature_plus: Digicert::ClientCertificate::DigitalSignaturePlus,
      }
    end
  end
end
