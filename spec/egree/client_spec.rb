require "spec_helper"
require "egree/client"

RSpec.describe Egree::Client do
  describe ".new" do
    it "instantiates with username and password" do
      client = Egree::Client.new username: "admin", password: "secret"

      expect(client.username).to eq "admin"
      expect(client.password).to eq "secret"
    end

    it "defaults username to environment variable EGREE_USERNAME" do
      ENV["EGREE_USERNAME"] = "some name"

      expect(Egree::Client.new.username).to eq "some name"
    end

    it "defaults password to environment variable EGREE_PASSWORD" do
      ENV["EGREE_PASSWORD"] = "very-secret"

      expect(Egree::Client.new.password).to eq "very-secret"
    end
  end
end
