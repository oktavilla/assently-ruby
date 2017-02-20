require "spec_helper"
require "assently/api_mappers/party_mapper"

module Assently
  module ApiMappers
    RSpec.describe PartyMapper do
      describe ".to_api" do
        it "creates a hash that matches the api's expected format" do
          party = double("Party", {
            name: "First Last",
            email: "first-last@example.com",
            social_security_number: "1234567890"
          })

          expect(PartyMapper.to_api(party)).to eq({
            "Name" => "First Last",
            "EmailAddress" => "first-last@example.com",
            "SocialSecurityNumber" => "1234567890"
          })
        end
      end
    end
  end
end
