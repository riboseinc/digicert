module Digicert
  class CSRGenerator
    def initialize(domain:, organization:)
      @domain_name = domain
      @organization = organization
    end

    def generate
      openssl_request_instance.to_s
    end

    def self.generate(domain:, organization:)
      new(domain: domain, organization: organization).generate
    end

    private

    attr_reader :organization, :domain_name

    def openssl_request_instance
      OpenSSL::X509::Request.new.tap do |reqeust|
        reqeust.version = 0
        reqeust.subject = openssl_name_instance
        reqeust.public_key = rsa_key.public_key

        reqeust.sign(rsa_key, OpenSSL::Digest::SHA1.new)
      end
    end

    def rsa_key
      OpenSSL::PKey::RSA.new(File.read(rsa_key_file))
    end

    def openssl_name_instance
      OpenSSL::X509::Name.new([
        ["C",  organization.country, OpenSSL::ASN1::PRINTABLESTRING],
        ["ST", organization.state,   OpenSSL::ASN1::PRINTABLESTRING],
        ["L",  organization.city,    OpenSSL::ASN1::PRINTABLESTRING],
        ["O",  organization.name,    OpenSSL::ASN1::UTF8STRING],
        ["CN", domain_name, OpenSSL::ASN1::UTF8STRING],
      ])
    end

    def rsa_key_file
      rsa_key_path = "../../fixtures/rsa4096.key"
      File.expand_path(rsa_key_path, __FILE__)
    end
  end
end
