require "spec_helper"

RSpec.describe Digicert::Product do
  describe ".all" do
    it "retrieves all of the products" do
      stub_digicert_product_list_api
      products = Digicert::Product.all

      expect(products.count).to eq(16)
      expect(products.first.name).not_to be_nil
      expect(products.first.type).not_to be_nil
      expect(products.first.name_id).not_to be_nil
    end
  end
end
