require "r509"

module Digicert
  class CSRGenerator
    def initialize(common_name:, organization:, san_names: [], rsa_key: nil)
      @rsa_key = rsa_key
      @common_name = common_name
      @san_names = san_names
      @organization = organization
    end

    def generate
      create_r509_csr.to_s
    end

    def self.generate(attributes)
      new(**attributes).generate
    end

    private

    attr_reader :organization, :common_name, :san_names, :rsa_key

    def create_r509_csr
      R509::CSR.new(r509_attributes_hash)
    end

    def r509_attributes_hash
      { key: rsa_key, subject: subject_items, san_names: san_names }.
        reject { |_key, value| value.nil? || value.empty? }
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
  end
end
