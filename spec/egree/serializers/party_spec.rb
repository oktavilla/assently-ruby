require "spec_helper"
require "egree/serializers/party"

module Egree
  module Serializers
    RSpec.describe Party do
      describe ".serialize" do
        it "returns a json string of the api hash" do
          party = double "Party"

          expect(Party).to receive(:to_api_hash).with(party).and_return(party: "hash")

          expect(Party.serialize(party)).to eq JSON.pretty_generate(party: "hash")
        end
      end

      describe ".to_api_hash" do
        it "creates a hash that matches the api's expected format" do
          party = double("Party", {
            name: "First Last",
            email: "first-last@example.com",
            social_security_number: "1234567890"
          })

          expect(Party.to_api_hash(party)).to eq({
            "Name" => "First Last",
            "EmailAddress" => "first-last@example.com",
            "SocialSecurityNumber" => "1234567890"
          })
        end
      end
    end
  end
end
