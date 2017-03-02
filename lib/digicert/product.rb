require "digicert/base"

module Digicert
  class Product < Digicert::Base
    include Digicert::Actions::All
    include Digicert::Actions::Fetch

    private

    def resource_path
      "product"
    end
  end
end
