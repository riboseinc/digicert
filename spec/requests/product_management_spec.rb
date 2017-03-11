require "spec_helper"

RSpec.describe "Product Management" do
  describe "fetching a specific product", api_call: true do
    it "fetches the details for a specific product" do
      product = Digicert::Product.fetch(product_name_id)

      expect(product.name).to eq("SSL Plus")
      expect(product.allowed_validity_years).to eq([1, 2, 3])
      expect(product.signature_hash_types.default_hash_type_id).to eq("sha256")
    end
  end

  def product_name_id
    @name_id ||= products.first.name_id
  end

  def products
    # We are intentionally making this api call to verify
    # the `.all` interface is working as it should have.
    #
    @products ||= Digicert::Product.all
  end
end
