# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

# https://www.digicert.com/services/v2/documentation/order/order-client-premium

module Digicert::Order
  class Private < Base

    CREATE_METHOD = "POST"
    CREATE_ENDPOINT = "https://www.digicert.com/services/v2/order/certificate/client_premium_sha2"

    # For signature_hash
    ALLOWED_HASHES = %w(sha1)

    def issue(client)
      raise ArgumentError.new("Already created!") if id

      mandatory = %w(csr common_name emails signature_hash organization_id validity_years)
      missing_mandatory = mandatory.all do |k|
        send(k).nil?
      end

      if missing_mandatory
        raise ArgumentError.new("Must contain at least these #{mandatory.inspect} elements to create")
      end

      params = {
        certificate: {
          common_name: common_name,
          emails: emails,
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

  end
end


__END__
Submitting Orders - Order Client Premium Certificate

Use this endpoint to create a client certificate that can be used for email
encryption and signing, client authentication, and document signing.

NOTE: client certificates do not require additonal approval after the order is created.

Request Endpoint

Method	URL
POST	https://www.digicert.com/services/v2/order/certificate/client_premium_sha2
Request Body

This endpoint accepts a request body in one of the following formats:
application/json
application/xml
JSON Request Parameters

Parameter Name	Req/Opt	Allowed Values	Default	Description
certificate	Required	[object]
  common_name	Required	[string]
    The name to be secured in the certificate
  emails	Required	[array]
    Emails to be placed in the certificate
  csr	Required	[string]
    Certificate Signing Request. To create a CSR from your server, visit the DigiCert Website.
    For Code Signing, CSR is only required/permitted for Java platform (server_platform.id = 55).
    For EV Code Signing, CSR is only required for email provisioning.
    For client certificates, the CSR is optional.
signature_hash	Required	sha256, sha384, sha512 (sha1 on private certs)
  The certificate's signing algorithm hash, for code signing only sha256 is supported.
organization	Required	[object]
  id	Required	[int]
    The organization's identifier
validity_years	Required	[int]
  Number of years that the certificate is valid.
auto_renew	Optional	[int]
  For client certs, the new number of times the certificate should renew automatically. For ssl certs, whether the order should auto renew at expiration or not.
renewal_of_order_id	Optional	[int]
  If this order is a renewal of a previous order, add the previous order's id to this parameter

JSON Response Parameters

Parameter Name	Data Type	Description
id	[int]	The order's identifier


Sample Request

Endpoint

https://www.digicert.com/services/v2/order/certificate/client_premium_sha2

Headers

X-DC-DEVKEY: A6g14f4rV21413813nr945n1rbzra6qwnwy285r9g33sfdn
Content-Type: application/json
Content-Length: 347

Body

JSON (application/json)
{
  "certificate": {
    "common_name": "Full Name",
    "emails": [
      "email@example.com",
      "email2@example.com"
    ],
    "csr": "-----BEGIN CERTIFICATE REQUEST----- ... -----END CERTIFICATE REQUEST-----",
    "signature_hash": "sha256"
  },
  "organization": {
    "id": 117483
  },
  "validity_years": 3,
  "auto_renew": 10,
  "renewal_of_order_id": 314152
}


Sample Response

Status Code: 201

Headers

Content-Type: application/json
Content-Length: 17

Body

JSON (application/json)
{
  "id": 542754
}
