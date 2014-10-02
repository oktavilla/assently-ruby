require "spec_helper"
require "egree"

RSpec.describe Egree do
  describe ".client" do
    it "returns a Egree::Client" do
      expect(Egree.client("admin", "secret")).to be_kind_of Egree::Client
    end

    it "passes arguments to the client" do
      client = Egree.client "admin", "secret"

      expect(client.username).to eq "admin"
      expect(client.password).to eq "secret"
    end
  end
end
