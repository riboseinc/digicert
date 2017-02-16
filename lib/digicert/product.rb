require "digicert/request"

module Digicert
  class Product
    def self.all
      response = Digicert::Request.new(:get, "product").run
      response.products
    end

    def self.fetch(name_id)
      Digicert::Request.new(:get, ["product", name_id].join("/")).run
    end
  end
end
