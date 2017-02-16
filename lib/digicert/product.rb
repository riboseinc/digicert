require "digicert/request"

module Digicert
  class Product
    def self.all
      response = Digicert::Request.new(:get, "product").run
      response.products
    end
  end
end
