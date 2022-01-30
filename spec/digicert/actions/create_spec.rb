require "spec_helper"
require "digicert/base"

RSpec.describe "Digicert::Actions::Create" do
  describe ".create" do
    it "creates a new resource" do
      stub_digicert_container_create_api(**container_attributes)
      resource = Digicert::TestCreateAction.create(container_attributes)

      expect(resource.id).not_to be_nil
    end
  end

  module Digicert
    class TestCreateAction < Digicert::Base
      include Digicert::Actions::Create

      def initialize(attributes = {})
        @container_id = attributes.delete(:container_id)
        super
      end

      private

      def resource_creation_path
        ["container", @container_id, "children"].join("/")
      end

      def validate(name:, template_id:, **attributes)
        {
          name: name,
          template_id: template_id,

        }.merge(attributes)
      end
    end
  end

  def container_attributes
    {
      container_id: 123_456_789,
      name: "History Department",
      template_id: 5,
      description: "History, Civ, Ancient Languages",
    }
  end
end
