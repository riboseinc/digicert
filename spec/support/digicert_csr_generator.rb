require "r509"

module Digicert
  class CSRGenerator
    def initialize(common_name:, organization:, san_names: [])
      @common_name = common_name
      @san_names = san_names
      @organization = organization
    end

    def generate
      create_r509_csr.to_s
    end

    def self.generate(attributes)
      new(attributes).generate
    end

    private

    attr_reader :organization, :common_name, :san_names

    def create_r509_csr
      R509::CSR.new(
        key: rsa_key_file, subject: subject_items, san_names: san_names,
      )
    end

    def subject_items
      [
        ["CN", common_name],
        ["C",  organization.country],
        ["ST", organization.state],
        ["L",  organization.city],
        ["O",  organization.name],
      ]
    end

    def rsa_key_file
      rsa_key_path = "../../fixtures/rsa4096.key"
      File.read(File.expand_path(rsa_key_path, __FILE__))
    end
  end
end
