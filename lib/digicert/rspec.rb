# Test Helpers for RSpec
#
# Actual API requests are slow and expensive and we try not to make actual
# API request when possible. For most of our tests we mock the API call which
# verifies the endpoint, http verb and headers and based on those it responses
# with an identical fixture file.
#
# The main purpose of this file is to allow you to use our test helpers by
# simplify adding this file to your application and then use the available
# helper  method when necessary.
#
# Please check `spec/support` directory to see the available helper methods.
#
# We do not include this module with the gem by default, but you can do so
# by adding `require "digicert/rspec"` on top of your `spec_helpe` file.
#
require File.join(Digicert.root, "spec/support/fake_digicert_api.rb")

RSpec.configure do |config|
  config.include Digicert::FakeDigicertApi
end
