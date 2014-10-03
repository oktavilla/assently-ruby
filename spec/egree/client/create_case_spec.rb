require "luhn"
require "spec_helper"

require "egree/client"
require "egree/case"
require "egree/document"
require "egree/party"

module Egree
  describe Egree::Client do
    describe "#create_case" do
      let :client do
        Egree::Client.new ENV["EGREE_USERNAME"], ENV["EGREE_PASSWORD"], :test
      end

      it "sends the create case comamnd with a json representation of the case" do
        allow(client).to receive :post

        signature_case = double "Case"
        options = { postback_url: "http://example.com/postback" }

        expect(Egree::Serializers::CaseSerializer).to receive(:serialize).with(signature_case, options).and_return "case-json"

        client.create_case signature_case, options

        expect(client).to have_received(:post).with "/apiv1/createcasecommand", "case-json"
      end

      describe "with a valid case", vcr: { cassette_name: "Egree_Client/_create_case/valid_case" } do
        it "returns a successful result object" do
          signature_case = Egree::Case.new "Agreement", ["touch"]
          signature_case.add_party Egree::Party.new_with_attributes({
            name: "First Last",
            email: "name@example.com",
            social_security_number: Luhn::CivicNumber.generate
          })
          signature_case.add_document Egree::Document.new(File.join(Dir.pwd, "spec/fixtures/agreement.pdf"))

          result = client.create_case(signature_case, {
            postback_url: "http://example.com/postback",
            continue: {
              name: "Back to the site",
              url: "http://example.com/thanks",
              auto: true
            },
            locale: "sv"
          })

          expect(result.success?).to be true
        end
      end

      describe "with an invalid case" do
        it "returns a error result object", vcr: { cassette_name: "Egree_Client/_create_case/invalid_case" } do
          signature_case = Egree::Case.new "Agreement", ["touch"]

          result = client.create_case signature_case

          expect(result.success?).to be false
        end

        it "includes the error message", vcr: true do
          signature_case = Egree::Case.new "Agreement", ["touch"]
          signature_case.add_document Egree::Document.new(File.join(Dir.pwd, "spec/fixtures/agreement.pdf"))

          result = client.create_case signature_case

          expect(result.errors[0]).to eq "E041 At least one signer is required."
        end
      end
    end
  end
end
