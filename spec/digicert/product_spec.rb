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

  describe ".fetch" do
    it "retrieves the specified product" do
      product_name_id = "ssl_plus"

      stub_digicert_product_fetch_api(product_name_id)
      product = Digicert::Product.fetch(product_name_id)

      expect(product.name).to eq("SSL Plus")
      expect(product.type).to eq("ssl_certificate")
      expect(product.server_platforms.first.name).to eq("Apache")
    end
  end
end
