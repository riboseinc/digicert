Ruby API client for DigiCert certificate list/order service
===========================================================

WARNING: freelancer must be willing to sign a contractor agreement covering confidentiality and IP rights. This means that you need to provide real details. No fake profiles please.

This work is to enhance an existing Ruby API client developed to access the DigiCert Services API in a "Ruby-way". Most of the models below have already been implemented, but these methods listed are extra ones that need to be implemented. We will share the code and a development account to test the API when we start.

This involves modelling the following objects and actions.

Product object
--------------------
* ```#all```
  * https://www.digicert.com/services/v2/documentation/product/product-list

* ```#fetch/get```
  * https://www.digicert.com/services/v2/documentation/product/product-details


Certificate object
--------------------
* ```#order```
* ```#download(:format)```
  * Download a Certificate
    * https://www.digicert.com/services/v2/documentation/certificate/download
  * Download a Client Certificate
    * https://www.digicert.com/services/v2/documentation/certificate/download-client-certificate

* ```#revoke```: Revoke a Certificate
  * https://www.digicert.com/services/v2/documentation/certificate/revoke

* ```#duplicate```: Duplicate Certificate
  * https://www.digicert.com/services/v2/documentation/order/duplicate

* ```#duplicates```: List Duplicate Certificates
  * https://www.digicert.com/services/v2/documentation/order/duplicate-list



Order object
-------------
* Types
  * ```https://www.digicert.com/services/v2/documentation/order/#{type}```
  * Order SSL Plus Certificate
    * ```order-ssl-plus```

  * Order SSL Wildcard Certificate
    * ```order-ssl-wildcard```

  * Order SSL EV Plus Certificate
    * ```order-ssl-ev-plus```

  * Order Client Premium Certificate
    * ```order-client-premium```

  * Order Client Email Security Plus Certificate
    * ```order-client-email-security-plus```

  * Order Client Digital Signature Plus Certificate
    * ```order-client-digital-signature-plus```

* Methods
  * ```#all``` List Certificate Orders
    * https://www.digicert.com/services/v2/documentation/order/order-list

  * ```#fetch(:id)``` Get Certificate Orders
    * https://www.digicert.com/services/v2/documentation/order/view

  * ```#email_validations``` List of Email Validations
    * https://www.digicert.com/services/v2/documentation/order/email-validation-list

  * ```#validate_email``` Validate an Email Address
    * https://www.digicert.com/services/v2/documentation/order/validate-email-address

  * ```#reissue``` Reissue a Certificate Order
    * https://www.digicert.com/services/v2/documentation/order/reissue

  * ```#duplicate``` Duplicate Certificate
    * https://www.digicert.com/services/v2/documentation/order/duplicate

  * ```#duplicates``` List Duplicate Certificates
    * https://www.digicert.com/services/v2/documentation/order/duplicate-list

  * ```#cancel```: Cancel a Certificate Order
    * https://www.digicert.com/services/v2/documentation/order/cancel

  * ```expiring```: Expiring Orders
    * https://www.digicert.com/services/v2/documentation/reports/expiring-orders



Organization object
-------------------
* ```#all```: Get Organizations available for new orders
  * https://www.digicert.com/services/v2/documentation/order/organization-list


Request object
---------------

* ```#all```: List Requests
  * https://www.digicert.com/services/v2/documentation/request/list

* ```#fetch/get```: View Request
  * https://www.digicert.com/services/v2/documentation/request/request

* ```#update```: Update Request Status
  * https://www.digicert.com/services/v2/documentation/request/status


Sample usage
----------------

Validating account permissions.

Api client should fetch from Digicert API on what products are available
for the account, and what actions are allowed:

```ruby
Client.new(digicert_api_key)
Client.products
# => [ Digicert::Product::Certificate::Ssl, ... ]
```

Creating a new order to obtain a certificate:
```ruby
order = Digicert::Order::EvSsl.new(
  domain: "hello.com",
  validity_years: 3
)

order.issue
while order.status == "PENDING" do
  sleep 10
  order.refresh
end

request = order.request
request.approve
```

Downloading an issued certificate:
```ruby
cert = Digicert::Certificate.fetch(123456)
cert.download(format: "pem")
```

Order actions:
```ruby
order = Digicert::Order.fetch(1234)
order.reissue
order.cancel
certificate = order.certificate
certificate.issuer
certificate_2 = certificate.duplicate
certificate.duplicates # => list of duplicated certificates
certificate.revoke
```

References
============

DigiCert Services API
* https://www.digicert.com/services/v2/documentation)

Sample API libraries for reference:
* https://github.com/opendns/lemur-digicert/blob/master/lemur_digicert/plugin.py
* https://github.com/digicert/digicert_client

