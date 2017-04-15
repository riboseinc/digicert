# Digicert

[![Build
Status](https://travis-ci.org/riboseinc/digicert.svg?branch=master)](https://travis-ci.org/riboseinc/digicert)
[![Code
Climate](https://codeclimate.com/github/riboseinc/digicert/badges/gpa.svg)](https://codeclimate.com/github/riboseinc/digicert)

The Ruby client for the official Digicert API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "digicert"
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install digicert
```

## Configure

Once you have your API key then you can configure it by adding an initializer
with the following code

```ruby
Digicert.configure do |config|
  config.api_key = "SECRET_DEV_API_KEY"

  # Default response type is `object`, but you
  # can configure it if necessary, and all the
  # further response will be return as config
  # supported options are `object`, `hash`
  #
  # config.response_type = :object
end
```

Or

```ruby
Digicert.configuration.api_key = "SECRET_DEV_API_KEY"
```

## Usage

### Container

Container is an Operational Division used to model your organizational
structure. The features of the container you create are determined by
its Container Template.

#### List Containers

Use this interface to retrieve a list of existing containers.

Note: This is an undocumented endpoint of the DigiCert Services API.

```ruby
Digicert::Container.all
```

#### Create a Container

Use this interface to create new container, and this interface also
expects us to provide `parent_container` along with the others
attributes as `container_id`.

```ruby
Digicert::Container.create(
  container_id: 123_456_789,
  template_id: 5,
  name: "History Department",
  description: "History, Civ, Ancient Languages",

  user: {
    first_name: "Awesome",
    last_name: "User",
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

### Container Template

Container Templates define a set of features that are available to a container.

#### List Container Templates

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

### Organization

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

#### List all organizations

Use this interface to retrieve a list of organizations.

```ruby
Digicert::Organization.all
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

#### View a Domain

Use this interface to view a domain, This interface also allows you to pass an
additional `hash` to specify if you want to retrieve additional data with the
response.

```ruby
Digicert::Domain.fetch(domain_id, include_dcv: true)
```

#### List Domains

Use this interface to retrieve a list of domains. This interface also supports
an additional `filter_params` hash, which can be used to filter the list we want
the interface to return.

```ruby
Digicert::Domain.all(filter_params_hash)
```

### Submitting Orders

#### View Product List

Use this interface to retrieve a list of available products for an account.

```ruby
Digicert::Product.all
```

#### View Product Details

Use this interface to retrieve a full set of details for a product.

```ruby
Digicert::Product.fetch(name_id)
```

#### Generate the CSR content

This interface will allow us to generate the CSR content on the fly, it will
return the content that we can use for order creation.

```ruby
Digicert::CSRGenerator.generate(
  common_name: "example.com",
  san_names: ["example.com", "www.example.com"],
  rsa_key: File.read("your_rsa_key_file_path"),
  organization: Digicert::Organization.first,
)
```

#### Create any type of order

Use this interface to create a new order, this expect two arguments one is
`name_id` for the order and another one is the attributes hash.

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

The supported value for `name_id` are `ssl_plus`, `ssl_wildcard`, `ssl_ev_plus`,
`client_premium`, `email_security_plus` and `digital_signature_plus`. Please
check the Digicert documentation for more details on those.

If you want to create a new order by yourself by following each of the specific
class then please check out the interfaces specified bellow.

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

Use this interface to order a Client Digital Signature Plus

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

### Request Management

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

### Order Management

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

#### Validate an Email Address

Use this interface to verify control of an email address, using an email
address/token pair.

```ruby
Digicert::EmailValidation.valid?(token: token, email: email)
# => true or false
```

#### Reissue a Certificate Order

Use this interface to reissue a certificate order. A reissue replaces the
existing certificate with a new one that has different information such as
common name, CSR, etc. The simplest interface to reissue an update an existing
order is

```ruby
order = Digicert::Order.find(order_id)
order.reissue

# Alternative and prefereed in most case
Digicert::OrderReissuer.create(order_id: order_id)
```

And if there are some updated information like `csr`, `common_name` or etc then
you can use the same interface but pass the `:certificate` option. Please
remember if any required fields are missing then it will use the data that
already exists for that order.

```ruby
Digicert::OrderReissuer.create(
  order: order_id,
  certificate: {
    common_name: certificate_common_name,
    dns_names: [certificate_dns_name],
    csr: certificate_csr,
    signature_hash: certificate_signature_hash,
    server_platform: { id: certificate_server_platform_id },
  }
)
```

#### Duplicate a Certificate Order

Use this interface to request a duplicate certificate for an order. A duplicate
shares the expiration date as the existing certificate and is identical with the
exception of the CSR and a possible change in the server platform and signature
hash. The common name and sans need to be the same as the original order.

```ruby
Digicert::OrderDuplicator.create(
  order: order_id,
  certificate: {
    common_name: certificate_common_name,
    dns_names: [certificate_dns_name],
    csr: certificate_csr,
    signature_hash: certificate_signature_hash,
    server_platform: { id: certificate_server_platform_id },
  }
)
```

#### Find a Duplicate Certificate

As of now, the Digicert API, does not have an easier way to find a duplicate
certificate, as the certificate duplication returns existing `order_id` with a
`request` node which only has an `id`.

So to find out a duplicate certificate, we need to retrieve the details for that
specific request and from that response retrieve the `date_created` for the
duplicate certificate and then use that `date_created` to find out the correct
certificate from the duplications of that specific order.

This requires lots of work, so this following interface will do all of its
underlying tasks, and all we need to do is pass the requests id that we will
have form the certificate duplication.

```ruby
# Duplicate an existing certificate order
#
order = Digicert::Order.find(order_id)
duplicate_order = order.duplicate

# Use the request id to find out the certificate
#
request_id = duplicate_order.requests.first.id
Digicert::DuplicateCertificateFinder.find_by(request_id: request_id)
```

#### List Duplicate Certificates

Use this interface to view all duplicate certificates for an order.

```ruby
Digicert::DuplicateCertificate.all(order_id: order_id)

# Alternative interface for duplicate certificates
order = Digicert::Order.find(order_id)
order.duplicate_certificates
```

#### Cancel a Certificate Order

Use this interface to update the status of an order. Currently this endpoint only
allows updating the status to 'CANCELED'

```ruby
order = Digicert::Order.find(order_id)
order.cancel(note: "Cancellation note")

# Or use the actual interface for more control
Digicert::OrderCancellation.create(
  order_id: order_id, status: "CANCELED", note: "your_note", send_emails: true,
)
```

### Reports

#### Expiring Orders

Use this interface to retrieve the number of orders that have certificates
expiring within 90, 60, and 30 days. The number of orders that have already
expired certificates within the last 7 days is also returned.

```ruby
Digicert::ExpiringOrder.all(container_id: container_id)
```

### Certificate Management

#### Download a Certificate

This request will return an SSL Certificate file from an order. By default, it
uses the platform specified by the order.

```ruby
# Fetch the certficate details that includes a http status code
# and the file content in the `#body`, so you can choose if you
# want to write it to your filesystem or directly upload it to
# your host, and the contents it returns is `zip` archieve.
#
certificate = Digicert::CertificateDownloader.fetch(certificate_id, **attributes)

# write to content to somewhere in your filesystem.
#
File.write("path_to_file_system/certificate.zip", certificate.body)

# Alaternative to fetch it through certificate instance
#
certificate = Digicert::Certificate.find(certificate_id)
certificate_content_object = certificate.download
```

Additionally, if you want the gem to handle the file writing then it also
provides another helper interface `fetch_to_path`, and that will fetch the file
content and write the content to supplied path.

```ruby
Digicert::CertificateDownloader.fetch_to_path(
  certificate_id,
  ext: "zip",
  path: File.expand_path("./file/download/path"),
  **other_attributes_hash_like_platform_or_format,
)

# Alternative through a certificate instance
#
certificate = Digicert::Certificate.find(certificate_id)
certificate.download_to_path(path: "file/path", ext: "zip", format: "zip")
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

# Alternative using the certificate instance
#
certificate = Digicert::Certificate.find(certificate_id)
certificate_content_object = certificate.download(format: format)
```

#### Download a Certificate By Platform

This interface will return an SSL Certificate file from an order using the
platform specified.

```ruby
certificate = Digicert::CertificateDownloader.fetch_by_platform(
  certificate_id, platform: "apache",
)

# Alternative using the certificate instance
#
certificate = Digicert::Certificate.find(certificate_id)
certificate_content_object = certificate.download(platform: "apache")
```

#### Download a Certificate content

This interface will fetch a SSL Certificate and extract all of its subsidiary
certificates content and return as a hash with `certificate`, `root_certificate`
and `intermediate_certificate` keys.

```ruby
Digicert::CertificateDownloader.fetch_content(certificate_id)

# Alternative using certificate instance
#
certificate = Digicert::Certificate.find(certificate_id)
certificate.download_content
```

#### Revoke a Certificate

This interface will revoke a previously issued SSL Certificate.

```ruby
Digicert::Certificate.revoke(certificate_id, comments: "Your comment")
```

## Development

We are following Sandi Metz's Rules for this gem, you can read the
[description of the rules here] (http://robots.thoughtbot.com/post/50655960596/sandi-metz-rules-for-developers).
All new code should follow these rules. If you make changes in a pre-existing
file that violates these rules you should fix the violations as part of your
contribution.

### Setup

Clone the repository.

```sh
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/digicert-api
```

Setup your environment.

```sh
bin/setup
```

Run the test suite

```sh
bin/rspec
```

### Play Box

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

### Generate Docs

We've used some standard to write this usages guide and the gem, so if we want
then we can generate a pretty formatted doc using [YARD](http://yardoc.org/).
For simplicity we did not add the `doc` in this repo, but please follow the
following steps to generate the updated doc.

Install `yard`

```sh
gem install yard
```

Generate the documentation

```sh

# If you want to see what's available then
# please use yard --help
#
yard doc
```

Open the doc in the browser

```sh
open doc/index.html
```

## Contributing

First, thank you for contributing! We love pull requests from everyone. By
participating in this project, you hereby grant Ribose Inc. the right to grant
or transfer an unlimited number of non exclusive licenses or sub-licenses to
third parties, under the copyright covering the contribution to use the
contribution by all means.

Here are a few technical guidelines to follow:

1. Open an [issue][issues] to discuss a new feature.
1. Write tests to support your new feature.
1. Make sure the entire test suite passes locally and on CI.
1. Open a Pull Request.
1. [Squash your commits][squash] after receiving feedback.
1. Party!

[issues]: https://github.com/abunashir/digicert-api/issues
[squash]: https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature

## Credits

This gem is developed, maintained and funded by [Ribose Inc.](https://www.ribose.com)
