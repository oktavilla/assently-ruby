require "luhn"
require "securerandom"
require "spec_helper"

require "assently/client"
require "assently/case"
require "assently/document"
require "assently/party"

module Assently
  describe Assently::Client do
    let :client do
      Assently::Client.new ENV["ASSENTLY_API_KEY"], ENV["ASSENTLY_API_SECRET"], :test
    end

    describe "#get_case" do
      describe "with a case_id as argument" do
        it "sends the getcase query with the case id json" do
          allow(client).to receive :get

          case_id = SecureRandom.uuid

          client.get_case case_id

          expect(client).to have_received(:get).with "/api/v2/getcase", id: case_id
        end
      end

      describe "when the case exists", vcr: { cassette_name: "Assently_Client/_get_case/case_exists" } do
        let (:case_id) { "my-case-id" }

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

            expect(result).to be_a Assently::Client::SuccessResult
            expect(result.response["Parties"].first["PartyUrl"]).to match(/\Ahttps:\/\/test.assently.com\/c\/.*\z/)
          end
        end
      end

      describe "when there is no matching case" do
        describe "result", vcr: { cassette_name: "Assently_Client/_get_case/case_missing" } do
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
      signature_case = Assently::Case.new "Agreement", ["touch"], case_id: case_id
      signature_case.add_party Assently::Party.new_with_attributes({
        name: "First Last",
        email: "name@example.com",
        social_security_number: Luhn::CivicNumber.generate
      })
      signature_case.add_document Assently::Document.new(File.join(Dir.pwd, "spec/fixtures/agreement.pdf"))

      client.create_case signature_case
    end
  end
end

