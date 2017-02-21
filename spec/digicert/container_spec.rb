require "spec_helper"

RSpec.describe Digicert::Container do
  describe ".create" do
    it "creates a new sub container" do
      stub_digicert_container_create_api(container_attributes)
      container = Digicert::Container.create(container_attributes)

      expect(container.id).not_to be_nil
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
