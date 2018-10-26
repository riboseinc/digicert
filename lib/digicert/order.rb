require "digicert/base"
require "digicert/findable"

require "digicert/ssl_certificate/ssl_plus"
require "digicert/ssl_certificate/ssl_ev_plus"
require "digicert/ssl_certificate/ssl_wildcard"
require "digicert/ssl_certificate/ssl_multi_domain"
require "digicert/ssl_certificate/ssl_ev_multi_domain"

require "digicert/client_certificate/premium"
require "digicert/client_certificate/private_premium"
require "digicert/client_certificate/email_security_plus"
require "digicert/client_certificate/digital_signature_plus"

module Digicert
  class Order < Digicert::Base
    extend Digicert::Findable

    include Digicert::Actions::All
    include Digicert::Actions::Fetch

    def create
      certificate_klass.create(attributes)
    end

    def self.create(name_id, attributes)
      new(name_id: name_id, **attributes).create
    end

    def reissue(attributes = {})
      Digicert::OrderReissuer.create(order_id: resource_id, **attributes)
    end

    def duplicate(attributes = {})
      Digicert::OrderDuplicator.create(order_id: resource_id, **attributes)
    end

    def duplicate_certificates(attributes = {})
      Digicert::DuplicateCertificate.all(order_id: resource_id, **attributes)
    end

    def email_validations
      Digicert::EmailValidation.all(order_id: resource_id)
    end

    def cancel(note:, **attrs)
      Digicert::OrderCancellation.create(
        order_id: resource_id, note: note, **attrs,
      )
    end

    private

    attr_reader :name_id

    def extract_local_attribute_ids
      @name_id = attributes.delete(:name_id)
    end

    def resource_path
      "order/certificate"
    end

    def resources_key
      "orders"
    end

    def certificate_klass
      certificate_klass_hash[name_id.to_sym] ||
        Digicert::SSLCertificate::SSLPlus
    end

    def certificate_klass_hash
      {
        ssl_plus: Digicert::SSLCertificate::SSLPlus,
        ssl_wildcard: Digicert::SSLCertificate::SSLWildcard,
        ssl_ev_plus: Digicert::SSLCertificate::SSLEVPlus,
        ssl_multi_domain: Digicert::SSLCertificate::SSLMultiDomain,
        ssl_ev_multi_domain: Digicert::SSLCertificate::SSLEVMultiDomain,
        client_premium: Digicert::ClientCertificate::Premium,
        email_security_plus: Digicert::ClientCertificate::EmailSecurityPlus,
        digital_signature_plus: Digicert::ClientCertificate::DigitalSignaturePlus,
      }
    end
  end
end
