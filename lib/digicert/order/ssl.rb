# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert::Order
  class Ssl < Digicert::Order::Base
    # certificate:
    # attr_accessor :csr, :common_names, :emails, :signature_hash,
    #   # organization:
    #   :organization,
    #   :organization_id,
    #   :organization_name,
    #   # the rest:
    #   :validity_years, :auto_renew, :renewal_of_order_id,
    #   :order_id,
    #   :certificate,
    #   :status,
    #   :is_renewed,
    #   :date_created,
    #   :organization,
    #   :product,
    #   :has_duplicates,
    #   :price,
    #   :product_name_id,
    #   :container,
    #   :id

    # # https://www.digicert.com/services/v2/documentation/order/view
    # {
    #  "id": 542757,
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
    #  },
    #  "status": "needs_approval",
    #  "is_renewal": true,
    #  "is_renewed": false,
    #  "renewed_order_id": 0,
    #  "business_unit": "Some Unit",
    #  "date_created": "2014-08-19T18:16:07+00:00",
    #  "organization": {
    #    "name": "DigiCert, Inc.",
    #    "display_name": "DigiCert, Inc.",
    #    "is_active": true,
    #    "city": "Lindon",
    #    "state": "Utah",
    #    "country": "us"
    #  },
    #  "disable_renewal_notifications": false,
    #  "container": {
    #    "id": 5,
    #    "name": "College of Science"
    #  },
    #  "product": {
    #    "name_id": "ssl_plus",
    #    "name": "SSL Plus",
    #    "type": "ssl_certificate",
    #    "validation_type": "ov",
    #    "validation_name": "OV",
    #    "validation_description": "Normal Organization Validation"
    #  },
    #  "organization_contact": {
    #    "first_name": "Some",
    #    "last_name": "Guy",
    #    "email": "someguy@digicert.com",
    #    "telephone": "8015551212"
    #  },
    #  "technical_contact": {
    #    "first_name": "Some",
    #    "last_name": "Guy",
    #    "email": "someguy@digicert.com",
    #    "telephone": "8015551212"
    #  },
    #  "user": {
    #    "id": 153208,
    #    "first_name": "Clive",
    #    "last_name": "Collegedean",
    #    "email": "clivecollegedean@digicert.com"
    #  },
    #  "requests": [
    #    {
    #      "id": 1,
    #      "date": "2015-01-01T18:20:00+00:00",
    #      "type": "new_request",
    #      "status": "approved",
    #      "comments": "Form autofill"
    #    }
    #  ],
    #  "receipt_id": 123892,
    #  "cs_provisioning_method": "none",
    #  "send_minus_90": true,
    #  "send_minus_60": true,
    #  "send_minus_30": true,
    #  "send_minus_7": true,
    #  "send_minus_3": true,
    #  "send_plus_7": true,
    #  "public_id": "MZv8RhHDVl9R3Ieko3iMX89wvYT3bYPA",
    #  "allow_duplicates": false,
    #  "user_assignments": [
    #    {
    #      "id": 153208,
    #      "first_name": "Clive",
    #      "last_name": "Collegedean",
    #      "email": "clivecollegedean@digicert.com"
    #    }
    #  ]
    #}

    attr_accessor *%i(
      auto_renew
      purchased_dns_names
      is_out_of_contract
      disable_issuance_email
      last_reissued_date
    )

    def initialize options={}
      raise ArgumentError.new("only accepts options hash") unless options.is_a? Hash

      options.each_pair do |k, v|
        case k
        when "certificate"
          self.certificate = ::Digicert::Certificate::Ssl.new(v)

        when "organization"
          self.organization = ::Digicert::Organization.new(v)

        else
          puts "k is #{k}"
          self.send("#{k.to_s}=", v)

        end
      end

    end

    ALLOWED_HASHES = %w(sha256 sha384 sha512)

    def issue(client)
      if id
        raise ArgumentError.new "This order has already been issued and cannot be reissued."
      end

      mandatory_attrs = %w(csr common_name signature_hash organization_id validity_years)
      missing_mandatory = mandatory_attrs.all do |k|
        send(k).nil?
      end

      if missing_mandatory
        raise ArgumentError.new "Create action requires these mandatory attributes: #{mandatory_attrs.inspect}"
      end

      params = {
        certificate: {
          common_name: common_name,
          csr: csr,
          signature_hash: signature_hash
        },
        organization: {
          id: organization_id
        },
        validity_years: validity_years,
        comments: comments
      }

      client.post(
        self.class::CREATE_ENDPOINT,
        params.to_json
      ) do |curl|
        curl.verbose = true
      end

    end

    class << self
      # https://www.digicert.com/services/v2/order/certificate

      # TODO: support pagination according to API
      def list(client)
        orders = client.perform("https://www.digicert.com/services/v2/order/certificate") do |curl|
          curl.headers["Accept"] = "application/json"
          curl.verbose = true
        end

        orders["orders"].map do |o|
          new o
        end
      end

      def fetch_by_id(client, order_id)
        order = client.perform("https://www.digicert.com/services/v2/order/certificate/#{order_id}") do |curl|
          curl.headers["Accept"] = "application/json"
          curl.verbose = true
        end

        new order
      end

    end

    # https://www.digicert.com/services/v2/documentation/order/order-client-premium
    # POST https://www.digicert.com/services/v2/order/certificate/client_premium_sha2
    #
    # Request: {
    #  "certificate": {
    #    "common_name": "Full Name",
    #    "emails": [
    #      "email@example.com",
    #      "email2@example.com"
    #    ],
    #    "csr": "-----BEGIN CERTIFICATE REQUEST----- ... -----END CERTIFICATE REQUEST-----",
    #    "signature_hash": "sha256"
    #  },
    #  "organization": {
    #    "id": 117483
    #  },
    #  "validity_years": 3,
    #  "auto_renew": 10,
    #  "renewal_of_order_id": 314152
    #}
    #
    # Response:
    # {
    #  "id": 542754
    # }
    def issue
      # TODO: check if necessary params have been set:
      # certificate, organization, validity_years, auto_renew, renewal_of_order_id
      client.post(Endpoint.order_client_certificate) do |curl|
        curl.verbose = true
      end
    end

    # https://www.digicert.com/services/v2/documentation/order/duplicate
    # https://www.digicert.com/services/v2/order/certificate/{order_id}/duplicate
    # #
    def duplicate
      # TODO
    end

  end

end
