# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

require "digicert/ssl_certificate/ssl_plus"
require "digicert/ssl_certificate/ssl_ev_plus"
require "digicert/ssl_certificate/ssl_wildcard"

require "digicert/client_certificate/premium"
require "digicert/client_certificate/email_security_plus"
require "digicert/client_certificate/digital_signature_plus"

module Digicert
  class Order
    def initialize(name_id, attributes = {})
      @name_id = name_id
      @attributes = attributes
    end

    def create
      certificate_klass.create(attributes)
    end

    def self.create(name_id, attributes)
      new(name_id, attributes).create
    end

    private

    attr_reader :attributes

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
