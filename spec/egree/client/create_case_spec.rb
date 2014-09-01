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

        signature_case = double "Case", to_json: "case-json"

        client.create_case signature_case

        expect(client).to have_received(:post).with "/apiv1/createcasecommand", "case-json"
      end

      describe "with a valid case" do
        it "returns a successful result object", vcr: true do
          signature_case = Egree::Case.new "Agreement", ["touch"]
          signature_case.add_party Egree::Party.new_with_attributes({
            name: "First Last",
            email: "name@example.com",
            social_security_number: Luhn::CivicNumber.generate
          })
          signature_case.add_document Egree::Document.new(File.join(Dir.pwd, "spec/fixtures/agreement.pdf"))

          result = client.create_case signature_case

          expect(result.success?).to be true
        end
      end
    end
  end
end
