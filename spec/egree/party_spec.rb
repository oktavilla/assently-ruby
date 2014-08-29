require "spec_helper"
require "egree/party"

module Egree
  RSpec.describe Party do
    describe ".new_with_attributes" do
      let :party do
        Party.new_with_attributes({
          name: "Jane Doe",
          email: "jane@example.com",
          social_security_number: "191302275522"
        })
      end

      it "sets the name" do
        expect(party.name).to eq "Jane Doe"
      end

      it "sets the email address" do
        expect(party.email).to eq "jane@example.com"
      end

      it "has a social security number" do
        expect(party.social_security_number).to eq "191302275522"
      end
    end

    it "strips unwanted input from social security number" do
      party = Party.new
      party.social_security_number = "1913 02 27 - 5522"

      expect(party.social_security_number).to eq "191302275522"
    end
  end
end
