require "luhn"
require "spec_helper"

require "assently/client"
require "assently/case"
require "assently/document"
require "assently/party"

module Assently
  describe Assently::Client do
    describe "#create_case" do
      let :client do
        Assently::Client.new ENV["ASSENTLY_API_KEY"], ENV["ASSENTLY_API_KEY"], :test
      end

      it "sends the create case command with a json representation of the case" do
        allow(client).to receive :post

        signature_case = double "Case"
        options = { locale: "sv" }

        expect(Assently::Serializers::CaseSerializer).to receive(:serialize).with(signature_case, options).and_return "case-json"

        client.create_case signature_case, options

        expect(client).to have_received(:post).with "/api/v2/createcase", "case-json"
      end

      describe "with a valid case", vcr: { cassette_name: "Assently_Client/_create_case/valid_case" } do
        it "returns a successful result object" do
          signature_case = Assently::Case.new "Agreement", ["touch"]
          signature_case.add_party Assently::Party.new_with_attributes({
            name: "First Last",
            email: "name@example.com",
            social_security_number: Luhn::CivicNumber.generate
          })
          signature_case.add_document Assently::Document.new(File.join(Dir.pwd, "spec/fixtures/agreement.pdf"))

          result = client.create_case(signature_case, {
            continue: {
              name: "Back to the site",
              url: "http://example.com/thanks",
              auto: true
            },
            cancel_url: "http://example.com/sorry",
            procedure: "form",
            locale: "sv"
          })

          expect(result.success?).to be true
        end
      end
    end
  end
end
