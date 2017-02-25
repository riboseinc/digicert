# Digicert::Api

[![CircleCI](https://circleci.com/gh/abunashir/digicert-api/tree/master.svg?style=svg&circle-token=21edcc7e3704f7d5b689e87b9e3af658e34a5be4)](https://circleci.com/gh/abunashir/digicert-api/tree/master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'digicert-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install digicert-api

## Configure

Once you have your API key then you can configure it by adding an initializer
with the following code

```ruby
Digicert.configure do |config|
  config.api_key = "SECRET_DEV_API_KEY"
end
```

Or

```ruby
Digicert.configuration.api_key = "SECRET_DEV_API_KEY"
```

## Usage

### Container

#### List Container Templates

Container Templates define a set of features that are available to a container.
Use this interface to retrieve a list of the templates that are available to use
to create child containers.

```ruby
Digicert::ContainerTemplate.all(container_id)
```

#### View a Container Template

Use this interface to retrieve information about a specific container template,
including which user access roles are available under this template.

```ruby
Digicert::ContainerTemplate.fetch(
  template_id: template_id, container_id: container_id,
)
```

#### Create a Container

Container is an Operational Division used to model your organizational
structure. The features of the container you create are determined by its
Container Template. Use this interface to create new container, and this
interface also expects us to provide `parent_container` along with the others
attributes as `container_id`.

```ruby
Digicert::Container.create(
  container_id: 123_456_789,
  template_id: 5,
  name: "History Department",
  description: "History, Civ, Ancient Languages",

  user: {
    first_name: "Awesome",
    last_name: "User"
    email: "awesomeuser@example.com",
    username: "awesomeuser@example.com",
    access_roles: [{ id: 1 }],
  },
)
```

#### View a Container

Information about a specific container can be retrieved through this interface,
including its name, description, template, and parent container id.

```ruby
Digicert::Container.fetch(container_id)
```

### Product

#### List Products

Use this interface to retrieve a list of available products for an account.

```ruby
Digicert::Product.all
```

#### Product details

Use this interface to retrieve a full set of details for a product.

```ruby
Digicert::Product.fetch(name_id)
```

### Certificate Request

#### List certificate requests

Use this interface to retrieve a list of certificate requests.

```ruby
Digicert::CertificateRequest.all
```

#### Certificate Request details

Use this interface to retrieve the details for a certificate request.

```ruby
Digicert::CertificateRequest.fetch(request_id)
```

#### Update Request Status

Use this interface to update the status of a previously submitted certificate
request.

```ruby
Digicert::CertificateRequest.update(
  request_id, status: "approved", processor_comment: "Your domain is approved",
)
```

### Order

### Create a new order

Use this interface to create a new order, this expect two arguments one is
`name_id` for the order and another one is the attributes hash for the order.

```ruby
order = Digicert::Order.create(
  name_id, order_attributes_hash,
)

# Pay close attension building the order attributes
# hash, it requries to format the data in a specific
# format and once that is satisfied only then it will
# perfrom the API operation otherwise it will raise
# invalid argument errors.
#
order_attributes = {
  certificate: {
    common_name: "digicert.com",
    csr: "------ [CSR HERE] ------",
    signature_hash: "sha256",

    organization_units: ["Developer Operations"],
    server_platform: { id: 45 },
    profile_option: "some_ssl_profile",
  },

  organization: { id: 117483 },
  validity_years: 3,
  custom_expiration_date: "2017-05-18",
  comments: "Comments for the the approver",
  disable_renewal_notifications: false,
  renewal_of_order_id: 314152,
  payment_method: "balance",
}
```

The supported `name_id`'s are `ssl_plus`, `ssl_wildcard`, `ssl_ev_plus`,
`client_premium`, `email_security_plus` and `digital_signature_plus`. Please
check the Digicert documentation for more details on those.

#### View a Certificate Order

Use this interface to retrieve a certificate order and the response includes all
the order attributes along with a `certificate` in it.

```ruby
Digicert::Order.fetch(order_id)
```

#### List Certificate Orders

Use this interface to retrieve a list of all certificate orders.

```ruby
Digicert::Order.all
```

#### Order SSL Plus Certificate

Use this interface to order a SSL Plus Certificate.

```ruby
Digicert::SSLCertificate::SSLPlus.create(
  certificate: {
    common_name: "digicert.com",
    csr: "------ [CSR HERE] ------",
    signature_hash: "sha256",

    organization_units: ["Developer Operations"],
    server_platform: { id: 45 },
    profile_option: "some_ssl_profile",
  },

  organization: { id: 117483 },
  validity_years: 3,
  custom_expiration_date: "2017-05-18",
  comments: "Comments for the the approver",
  disable_renewal_notifications: false,
  renewal_of_order_id: 314152,
  payment_method: "balance",
)
```

#### Order SSL Wildcard Certificate

Use this interface to order a SSL Wildcard Certificate.

```ruby
Digicert::SSLCertificate::SSLWildcard.create(
  certificate: {
    common_name: "digicert.com",
    csr: "------ [CSR HERE] ------",
    signature_hash: "sha256",

    organization_units: ["Developer Operations"],
    server_platform: { id: 45 },
    profile_option: "some_ssl_profile",
  },

  organization: { id: 117483 },
  validity_years: 3,
  custom_expiration_date: "2017-05-18",
  comments: "Comments for the the approver",
  disable_renewal_notifications: false,
  renewal_of_order_id: 314152,
)
```

#### Order SSL EV Plus Certificate

Use this interface to order a SSL EV Plus Certificate.

```ruby
Digicert::SSLCertificate::SSLEVPlus.create(
  certificate: {
    common_name: "digicert.com",
    csr: "------ [CSR HERE] ------",
    signature_hash: "sha256",

    organization_units: ["Developer Operations"],
    server_platform: { id: 45 },
    profile_option: "some_ssl_profile",
  },

  organization: { id: 117483 },
  validity_years: 3,
  custom_expiration_date: "2017-05-18",
  comments: "Comments for the the approver",
  disable_renewal_notifications: false,
  renewal_of_order_id: 314152,
)
```

#### Order Client Premium Certificate

Use this interface to order a Client Premium Certificate.

```ruby
Digicert::ClientCertificate::Premium.create(
  certificate: {
    common_name: "Full Name",
    emails: ["email@example.com", "email1@example.com"],
    csr: "------ [CSR HERE] ------",
    signature_hash: "sha256",

    organization_units: ["Developer Operations"],
    server_platform: { id: 45 },
    profile_option: "some_ssl_profile",
  },

  organization: { id: 117483 },
  validity_years: 3,
  custom_expiration_date: "2017-05-18",
  comments: "Comments for the the approver",
  disable_renewal_notifications: false,
  renewal_of_order_id: 314152,
)
```

#### Order Email Security Plus

Use this interface to order a Email Security Plus Certificate

```ruby
Digicert::ClientCertificate::EmailSecurityPlus.create(
  certificate: {
    common_name: "Full Name",
    emails: ["email@example.com", "email1@example.com"],
    signature_hash: "sha256",

    organization_units: ["Developer Operations"],
    server_platform: { id: 45 },
    profile_option: "some_ssl_profile",
  },

  organization: { id: 117483 },
  validity_years: 3,
  auto_renew: 10,
  renewal_of_order_id: 314152,
)
```

#### Order Client Digital Signature Plus

Use this interface to order a Order Client Digital Signature Plus

```ruby
Digicert::Order::DigitalSignaturePlus.create(
  certificate: {
    common_name: "Full Name",
    emails: ["email@example.com", "email1@example.com"],
    csr: "-----BEGIN CERTIFICATE REQUEST----- ...",
    signature_hash: "sha256",
  },

  organization: { id: 117483 },
  validity_years: 3,
  auto_renew: 10,
  renewal_of_order_id: 314152,
)
```

### Certificate Order

#### Certificate order details

Use this interface to retrieve a certificate order.

```ruby
Digicert::CertificateOrder.fetch(order_id)
```

### Organization

#### List all organizations

Use this interface to retrieve a list of organizations.

```ruby
Digicert::Organization.all
```

#### Create an Organization

Use this interface to create a new organization. The organization information
will be used by DigiCert for validation and may appear on certificates.

```ruby
# Create a new organization
# Please pay close attension bellow
# on building the organization_attributes
#
Digicert::Organization.create(organization_attributes)

# Organization attributes hash
#
organization_attributes = {
  name: "digicert, inc.",
  address: "333 s 520 w",
  zip: 84042,
  city: "lindon",
  state: "utah",
  country: "us",
  telephone: 8015551212,
  container: { id: 17 },

  organization_contact: {
    first_name: "Some",
    last_name: "Guy",
    email: "someguy@digicert.com",
    telephone: 8015551212,
  },

  # Optional attributes
  assumed_name: "DigiCert",
  address2: "Suite 500",
}
```

#### View an Organization

Use this interface to view information about an organization.

```ruby
Digicert::Organization.fetch(organization_id)
```

### Domain

#### Create a new Domain

Use this interface to add a domain for an organization in a container. You must
specify at least one validation type for the domain.

```ruby
# Create a new domain in an organization
# Please pay close attension in building the attibutes hash
#
Digicert::Domain.create(domain_attributes)

# Domain attributes hash
#
domain_attributes = {
  name: "digicert.com",
  organization: { id: 117483 },
  validations: [
    {
      type: "ev",
      user: { id: 12 }
    },
  ],

  dcv: { method: "email" },
}
```

#### List Domains

Use this interface to retrieve a list of domains. This interface also supports
an additional `filter_params` hash, which can be used to filter the list we want
the interface to return.

```ruby
Digicert::Domain.all(filter_params_hash)
```

#### View a Domain

Use this interface to view a domain, This interface also allows you to pass an
additional to `hash` to specify if you want to retrieve additional data with the
response.

```ruby
Digicert::Domain.fetch(domain_id, include_dcv: true)
```

#### Activate a Domain

Use this interface to activate a domain that was previously deactivated.

```ruby
domain = Digicert::Domain.find(domain_id)
domain.activate
```

#### Deactivate a Domain

Use this interface to deactivate a domain.

```ruby
domain = Digicert::Domain.find(domain_id)
domain.deactivate
```

### Certificate

#### Download a Certificate

This request will return an SSL Certificate file from an order. By default, it
uses the platform specified by the order.

```ruby
# Fetch the certficate details that includes a http status code
# and the file content in the `#body`, so you can choose if you
# want to write it to your filesystem or directly upload it to
# your host, and the contents it returns is `zip` archieve.
#
certificate = Digicert::CertificateDownloader.fetch(certificate_id)

# write to content to somewhere in your filesystem.
#
File.write("path_to_file_system/certificate.zip", certificate.body)
```

#### Download a Certificate By Format

This interface will return an SSL Certificate file from an order. The certificate
will be return in the format you specify, but one thing to remember the
certificate will be archived as `zip` along with the instructions, so you need
to write that as zip archive.

```ruby
Digicert::CertificateDownloader.fetch_by_format(
  certificate_id, format: format,
)
```

#### Download a Certificate By Platform

This interface will return an SSL Certificate file from an order using the
platform specified.

```ruby
certificate = Digicert::CertificateDownloader.fetch_by_platform(
  certificate_id, platform: "apache",
)
```

### Email Validations

#### List of Email Validations

Use this interface to view the status of all emails that require validation on a
client certificate order.

```ruby
Digicert::EmailValidation.all(order_id: order_id)

# If you prefer then there is an alternative alias method
# on the order class, you can invoke that on any of its
# instances. Usages
#
order = Digicert::Order.find(order_id)
order.email_validations
```

## Play Box

The API Play Box provides an interactive console so we can easily test out the
actual API interaction. But before moving forward let's configure the your key.

Setup the client configuration.

```sh
cp .sample.pryrc .pryrc
vim .pryrc
```

Start the console.

```sh
bin/console
```

Start playing with it.

```ruby
Digicert::Product.all
```

-- Previous usages guide ---

Run `bin/console` for an interactive prompt.

This is how you run it:

Set your API key in shell:
```sh
export DIGICERT_API_KEY="MY-KEY-ID"
export DIGICERT_TEST_ORDER_ID="MY-ORDER-ID-FOR-TESTING"
```

```ruby
$ bin/console
orders = Digicert.list_orders
order = Digicert.fetch_order
```
