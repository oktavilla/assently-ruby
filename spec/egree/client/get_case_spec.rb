require "luhn"
require "securerandom"
require "spec_helper"

require "egree/client"
require "egree/case"
require "egree/document"
require "egree/party"

module Egree
  describe Egree::Client do
    let :client do
      Egree::Client.new ENV["EGREE_API_KEY"], ENV["EGREE_API_SECRET"], :test
    end

    describe "#get_case" do
      describe "with a case_id as argument" do
        it "sends the getcase query with the case id json" do
          allow(client).to receive :post

          case_id = SecureRandom.uuid
          serialized_json = "{\n  \"id\": \"#{case_id}\"\n}"

          client.get_case case_id

          expect(client).to have_received(:post).with "/api/v2/getcase", serialized_json
        end
      end

      describe "when the case exists", vcr: { cassette_name: "Egree_Client/_get_case/case_exists" } do
        let (:case_id) { SecureRandom.uuid }

        before do
          create_case case_id
        end

        describe "result" do
          it "is successful" do
            result = client.get_case case_id

            expect(result.success?).to be true
          end

          it "has the url" do
            result = client.get_case case_id

            expect(result).to be_a Egree::Client::SuccessResult
            expect(result.response["Parties"].first["PartyUrl"]).to match(/\Ahttps:\/\/test.assently.com\/c\/.*\z/)
          end
        end
      end

      describe "when there is no matching case" do
        describe "result", vcr: { cassette_name: "Egree_Client/_get_case/case_missing" } do
          it "is not successfull" do
            result = client.get_case "missing-case"

            expect(result.success?).to be false
          end

          it "has the error" do
            result = client.get_case "missing-case"

            expect(result.errors[0]).to eq "EX404 Not Found Request parameters may not be well formed"
          end
        end
      end
    end

    private

    def create_case case_id = nil
      signature_case = Egree::Case.new "Agreement", ["touch"], case_id: case_id
      signature_case.add_party Egree::Party.new_with_attributes({
        name: "First Last",
        email: "name@example.com",
        social_security_number: Luhn::CivicNumber.generate
      })
      signature_case.add_document Egree::Document.new(File.join(Dir.pwd, "spec/fixtures/agreement.pdf"))

      client.create_case signature_case
    end
  end
end

