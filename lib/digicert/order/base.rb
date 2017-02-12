# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert::Order
  class Base

    # From here:
    # https://www.digicert.com/services/v2/documentation/order/view
    # With the addition of product_name_id, price, validity_years, has_duplicates
    #
    # This list of properties comes from the List Orders response.
    attr_accessor *%i(
      id
      certificate
      status
      is_renewal
      is_renewed
      renewed_order_id
      date_created
      organization
      disable_renewal_notifications
      container
      product
      organization_contact
      technical_contact
      user
      requests
      receipt_id
      cs_provisioning_method
      send_minus_90
      send_minus_60
      send_minus_30
      send_minus_7
      send_minus_3
      send_plus_7
      public_id
      allow_duplicates
      user_assignments
      payment_method
      price
      validity_years
      has_duplicates
      product_name_id
    )

    def initialize options={}
      raise ArgumentError.new "Abstract class cannot be instantiated." if self.class == Base
    end

    ALLOWED_HASHES = []
    def signature_hash=(hash)
      allowed_hashes = self.class.const_get(:ALLOWED_HASHES)

      unless allowed_hashes.include?(hash)
        raise ArgumentError.new "Signature hash provided {#{hash}} not one of allowed: #{allowed_hashes.inspect}"
      end

      super
    end

    def issue(client)
    end

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
    def issue(key)
      open(
        Endpoint.order_client_certificate,
        "X-DC-DEVKEY" => key,
        "Content-Type" => "application/json",
      ) {|f|
        f.each_line {|line| p line}
      }
    end

    # https://www.digicert.com/services/v2/documentation/order/duplicate
    # https://www.digicert.com/services/v2/order/certificate/{order_id}/duplicate
    # #
    def duplicate(client)

    end

  end
end

__END__

DOWNLOAD
============

Certificate Management - Download a Client Certificate

This request will return a Client Certificate file from an order. Currently,
Client Certificates can only be downloaded in the p7b format.

Request Endpoint

Method	URL
GET	https://www.digicert.com/services/v2/certificate/{certificate_id}/download/format/p7b

Sample Request

Endpoint

https://www.digicert.com/services/v2/certificate/542759/download/format/p7b

Headers

X-DC-DEVKEY: A6g14f4rV21413813nr945n1rbzra6qwnwy285r9g33sfdn
Accept: */*

Body

None

Sample Response

Status Code: 200

Headers

Content-Type: */*
Content-Length: 38
Body

The certificate file in the p7b format


DUPLICATES
===============


Order Management - List Duplicate Certificates

Use this endpoint to view all duplicate certificates for an order.

Request Endpoint

Method	URL
GET	https://www.digicert.com/services/v2/order/certificate/{order_id}/duplicate
JSON Response Parameters

Parameter Name	Data Type	Description
certificates	[array]
  id	[int]
    The certificate identifier
  thumbprint	[string]
    The certificate's thumbprint
  serial_number	[string]
    The certificate serial number.
  common_name	[string]
    The name to be secured in the certificate
  dns_names	[array]
    Additional names to be secured in the certificate. This may incur an
    additional cost.
  status	[string]
  date_created	[ISO 8601 date]
    Date will be returned in UTC timezone, formatted in ISO 8601.
  valid_from	[date]
    Date will be returned in format YYYY-MM-DD.
  valid_till	[date]
    Date will be returned in format YYYY-MM-DD.
  csr	[string]
    Certificate Signing Request. To create a CSR from your server, visit the
    DigiCert Website.
    For Code Signing, CSR is only required/permitted for Java platform
    (server_platform.id = 55).
    For EV Code Signing, CSR is only required for email provisioning.
    For client certificates, the CSR is optional.
  server_platform	[object]
    The server platform type. Defaults to other. For code signing, this field
    is required.  Reference: Server Platforms
    id	[int]
      The id of the server platform
    name	[string]
      The name of the server platform
    install_url	[string]
      The url with instructions of how to install a certificate.
    csr_url	[string]
      The url with instructions of how to create a CSR.
  signature_hash	[string]
    The certificate's signing algorithm hash, for code signing only sha256 is
    supported.  sha256, sha384, sha512 (sha1 on private certs)
  key_size	[int]
  ca_cert_id	[string]
    The private CA Cert ID that was purchased and assigned to your
    account/division
  sub_id	[string]
  public_id	[string]



Sample Request

Endpoint

https://www.digicert.com/services/v2/order/certificate/542757/duplicate

Headers

X-DC-DEVKEY: A6g14f4rV21413813nr945n1rbzra6qwnwy285r9g33sfdn
Accept: application/json

Body

None

Sample Response

Status Code: 200

Headers

Content-Type: application/json
Content-Length: 1503

Body

JSON (application/json)
{
  "certificates": [
    {
      "id": 1,
      "thumbprint": "B71DCBAF5586D6D95FC0B7EA1C74ADEF4A99F960",
      "serial_number": "0AE71279E5213729026AFE4BB58DE1AB",
      "common_name": "*.digicert.com",
      "dns_names": [
        "*.digicert.com",
        "digicert.com"
      ],
      "status": "approved",
      "date_created": "2014-08-19T18:16:07+00:00",
      "valid_from": "2014-08-19",
      "valid_till": "2015-08-24",
      "csr": "------ [CSR HERE] ------",
      "server_platform": {
        "id": 45,
        "name": "Barracuda",
        "install_url": "www.install.com",
        "csr_url": "www.csr.com"
      },
      "signature_hash": "sha256",
      "key_size": 2048,
      "ca_cert_id": "B71DCBAF5586D6D95FC0B7EA1C74ADEF4A99F960",
      "sub_id": "001",
      "public_id": "F7QIRX5P462QUYGQGRF26RSTL"
    },
    {
      "id": 2,
      "thumbprint": "B71DCBAF5586D6D95FC0B7EA1C74ADEF4A99F960",
      "serial_number": "0AE71279E5213729026AFE4BB58DE1AB",
      "common_name": "*.digicert.com",
      "dns_names": [
        "*.digicert.com",
        "digicert.com",
        "subdomain.digicert.com"
      ],
      "status": "approved",
      "date_created": "2014-08-19T18:16:07+00:00",
      "valid_from": "2014-08-19",
      "valid_till": "2015-08-24",
      "csr": "------ [CSR HERE] ------",
      "server_platform": {
        "id": 45,
        "name": "Barracuda",
        "install_url": "www.install.com",
        "csr_url": "www.csr.com"
      },
      "signature_hash": "sha256",
      "key_size": 2048,
      "ca_cert_id": "B71DCBAF5586D6D95FC0B7EA1C74ADEF4A99F960",
      "sub_id": "002",
      "public_id": "F7QIRX5P462QUYGQGRF26VLK"
    }
  ]
}


