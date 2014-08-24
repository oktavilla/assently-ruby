require "spec_helper"
require "egree"

RSpec.describe Egree do
  describe ".client" do
    it "creates a Egree::Client" do
      expect(Egree.client).to be_kind_of Egree::Client
    end

    it "passes arguments to the client" do
      client = Egree.client username: "admin"

      expect(client.username).to eq "admin"
    end
  end
end
