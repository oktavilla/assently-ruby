require "luhn"
require "spec_helper"

require "egree/client"
require "egree/case"
require "egree/document"
require "egree/party"

module Egree
  describe Egree::Client do
    let :client do
      Egree::Client.new ENV["EGREE_USERNAME"], ENV["EGREE_PASSWORD"], :test
    end

    describe "#get_case_url" do
      it "sends the getviewcaseurl query with the case reference id" do
        allow(client).to receive :post

        signature_case = double "Case", to_json: "reference-id-json"

        client.get_case_url signature_case

        expect(client).to have_received(:post).with "/apiv1/getviewcaseurlquery", "reference-id-json"
      end

      describe "when the case exists", vcr: { cassette_name: "Egree_Client/_get_case_url/case_exists" } do
        let :reference_id do
          Egree::Case.generate_reference_id
        end

        before do
          create_case reference_id
        end

        describe "result" do
          it "is successfull" do
            result = client.get_case_url reference_id

            expect(result.success?).to be true
          end

          it "has the url as the response" do
            result = client.get_case_url reference_id

            expect(result.response).to match "https://test.underskrift.se"
          end
        end
      end

      describe "when there is no matching case" do
        describe "result", vcr: { cassette_name: "Egree_Client/_get_case_url/case_missing" } do
          it "is not successfull" do
            result = client.get_case_url "missing-case"

            expect(result.success?).to be false
          end

          it "has the error" do
            result = client.get_case_url "missing-case"

            expect(result.errors[0]).to eq "E030 User is not creator of case."
          end
        end
      end
    end

    private

    def create_case reference_id = nil
      signature_case = Egree::Case.new "Agreement", ["touch"]
      signature_case.add_party Egree::Party.new_with_attributes({
        name: "First Last",
        email: "name@example.com",
        social_security_number: Luhn::CivicNumber.generate
      })
      signature_case.add_document Egree::Document.new(File.join(Dir.pwd, "spec/fixtures/agreement.pdf"))

      signature_case.reference_id = reference_id if reference_id

      client.create_case signature_case
    end
  end
end

