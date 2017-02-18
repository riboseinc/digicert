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

#### Order SSL Plus Certificate

Use this interface to order a SSL Plus Certificate.

```ruby
Digicert::Order::SSLPlus.create(
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
Digicert::Order::SSLWildcard.create(
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
Digicert::Order::SSLEVPlus.create(
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
