require "spec_helper"
require "assently/client"

module Assently
  describe Assently::Client do
    let :client do
      Assently::Client.new ENV["ASSENTLY_API_KEY"], ENV["ASSENTLY_API_SECRET"], :test
    end

    describe "#find_cases" do
      describe "with no arguments" do
        it "sends the findcase query" do
          allow(client).to receive :get

          client.find_cases

          expect(client).to have_received(:get).with "/api/v2/findcases", {}
        end
      end

      describe "with arguments" do
        it "sends the findcase query" do
          allow(client).to receive :get

          client.find_cases("Status" => "Finished")

          expect(client).to have_received(:get).with "/api/v2/findcases", { "Status" => "Finished"}
        end
      end

      describe "it returns a list of cases", vcr: { cassette_name: "Assently_Client/_find_cases/cases" } do
        describe "result" do
          it "is successful" do
            result = client.find_cases

            expect(result.success?).to be true

            expect(result.response.size).to eq 2
            expect(result.response[0]["Id"]).to eq "1833fe9e-271d-45cc-a97a-3e4b1c800408"
            expect(result.response[1]["Id"]).to eq "8174467c-3c3a-4f73-a96e-7166c998a648"
          end
        end
      end
    end
  end
end
