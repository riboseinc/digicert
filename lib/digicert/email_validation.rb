require "digicert/base"

module Digicert
  class EmailValidation < Digicert::Base
    include Digicert::Actions::All

    def self.all(order_id:, **filter_params)
      new(order_id: order_id, params: filter_params).all
    end

    def self.valid?(token:, email:)
      response = Digicert::Request.new(
        :put, ["email-validation", token].join("/"), params: {email: email }
      ).run

      response.code.to_i == 204
    end

    private

    attr_reader :order_id

    def extract_local_attribute_ids
      @order_id = attributes.delete(:order_id)
    end

    def resources_key
      "emails"
    end

    def resource_path
      ["order", "certificate", order_id, "email-validation"].join("/")
    end
  end
end
