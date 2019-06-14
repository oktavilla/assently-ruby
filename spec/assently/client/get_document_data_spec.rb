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

    describe "#get_document_data" do
      describe "with a case_id and document_id as argument" do
        it "sends the getdocumentdata query with the case id and document id" do
          allow(client).to receive :get

          case_id = SecureRandom.uuid
          document_id = SecureRandom.uuid

          client.get_document_data case_id, document_id

          expect(client).to have_received(:get).with "/api/v2/getdocumentdata", { "caseId" => case_id, "documentId" => document_id }
        end
      end

      describe "when the case exists", vcr: { cassette_name: "Assently_Client/_get_document_data/case_exists" } do
        let (:case_id) { "d9013f71-8983-4365-9450-19ea3c42cc90" }

        before do
          create_case case_id
        end

        describe "result" do
          it "contains the file" do
            exisiting_case = client.get_case(case_id).response
            document_id = exisiting_case["Documents"][0]["Id"]

            result = client.get_document_data exisiting_case["Id"], document_id

            expect(result).to be_a Assently::Client::SuccessResult
            expect(result.raw).to start_with("%PDF-1.3")
          end
        end
      end
    end

    private

    def create_case case_id = nil
      signature_case = Assently::Case.new "Agreement", ["touch"], id: case_id
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
