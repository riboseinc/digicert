require "spec_helper"
require "digicert/base"

RSpec.describe "Digicert::TestFindable" do
  describe ".find_by_object" do
    it "initialize an instnace using the object" do
      findable_object = double("order", id: 123_456_789)
      new_object = Digicert::TestFindable.find_by_object(findable_object)

      expect(new_object.class).to eq(Digicert::TestFindable)
    end
  end

  module Digicert
    class TestFindable < Digicert::Base
      extend Digicert::Findable
    end
  end
end
