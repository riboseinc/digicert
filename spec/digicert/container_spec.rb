require "spec_helper"

RSpec.describe Digicert::Container do
  describe ".all" do
    it "retrieves the list of containers" do
      stub_digicert_container_list_api
      containers = Digicert::Container.all

      expect(containers.first.id).not_to be_nil
      expect(containers.first.name).to eq("Ribose Inc.")
    end
  end

  describe ".create" do
    it "creates a new sub container" do
      stub_digicert_container_create_api(container_attributes)
      container = Digicert::Container.create(container_attributes)

      expect(container.id).not_to be_nil
    end
  end

  describe ".fetch" do
    it "retrieves the details for a container" do
      container_id = 123_456_789

      stub_digicert_container_fetch_api(container_id)
      container = Digicert::Container.fetch(container_id)

      expect(container.name).not_to be_nil
      expect(container.parent_id).not_to be_nil
      expect(container.allowed_domain_names.first).to eq("abc.xyz")
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
