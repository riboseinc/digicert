# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert::Certificate
  class Ssl < OpenStruct

    REQUEST_FORMAT_ATTRS = {
      certificate: {
        common_name: String,
        csr: String,
        organization_units: [ String ],
        # TODO: allowed requirements should come from the Digicert::Product API
        signature_hash: %w(sha256 sha384 sha512)
      },
      organization: {
        id: Integer
      },
      # TODO: allowed requirements should come from the Digicert::Product API
      validity_years: Integer,
      comments: String
    }

    REQUEST_ATTRS = %i(
      common_name csr organization_units signature_hash organization_id
      validity_years comments
    )
    GENERATED_ATTRS = %i(
      id thumbprint serial_number dns_names date_created valid_from
      valid_till server_platform key_size ca_cert status is_renewal
    )
    # attr_accessor :id, :common_name, :dns_names, :valid_till, :signature_hash,
    #   :csr, :thumbprint, :serial_number

    #  "certificate": {
    #    "id": 112358,
    #    "thumbprint": "7D236B54D19D5EACF0881FAF24D51DFE5D23E945",
    #    "serial_number": "0669D46CAE79EF684A69777490602485",
    #    "common_name": "digicert.com",
    #    "dns_names": [
    #      "digicert.com"
    #    ],
    #    "date_created": "2014-08-19T18:16:07+00:00",
    #    "valid_from": "2014-08-19",
    #    "valid_till": "2015-08-19",
    #    "csr": "------ [CSR HERE] ------",
    #    "organization": {
    #      "id": 117483
    #    },
    #    "organization_units": [
    #      "Digicert"
    #    ],
    #    "server_platform": {
    #      "id": 45,
    #      "name": "nginx",
    #      "install_url": "https:\/\/www.digicert.com\/ssl-certificate-installation-nginx.htm",
    #      "csr_url": "https:\/\/www.digicert.com\/csr-creation-nginx.htm"
    #    },
    #    "signature_hash": "sha256",
    #    "key_size": 2048,
    #    "ca_cert": {
    #      "id": "f7slk4shv9s2wr3",
    #      "name": "DCert Private CA"
    #    }

    # def initialize options={}
    #   options.each_pair do |k, v|
    #     send("#{k}=", v)
    #   end
    # end

    def download(client, format)
      accepted_formats = %w(pem p7b crt)
      unless accepted_formats.include? format
        raise ArgumentError.new("Only #{accepted_formats.inspect} formats accepted")
      end

      client.perform("https://www.digicert.com/services/v2/certificate/{certificate_id}/download/format/#{format}") do |curl|
        curl.headers["Accept"] = "*/*"
        curl.verbose = true
      end
    end

    # https://www.digicert.com/services/v2/documentation/order/duplicate
    # https://www.digicert.com/services/v2/order/certificate/{order_id}/duplicate
    # #
    def duplicate(order_id:)

    end

    # https://www.digicert.com/services/v2/documentation/certificate/download-client-certificate
    # https://www.digicert.com/services/v2/certificate/{certificate_id}/download/format/p7b
    #
    def download_client_certificate
      Endpoint.download_client_certificate

    end

    class << self
      def fetch_by_id(client, certificate_id)
        certificate_json = client.perform("https://www.digicert.com/services/v2/certificate/#{certificate_id}") do |curl|
          curl.headers["Accept"] = "application/json"
          curl.verbose = true
        end

        new certificate_json

      end

    end

  end
end
