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

## Usage

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

