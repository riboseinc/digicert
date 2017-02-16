require "digicert/base"

module Digicert
  class Product < Digicert::Base
    private

    def resource_path
      "product"
    end
  end
end
