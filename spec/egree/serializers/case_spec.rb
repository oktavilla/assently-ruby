require "spec_helper"
require "egree/serializers/case"

module Egree
  module Serializers
    RSpec.describe Case do
      it "serializes the case into the expected format" do
        party = double "Party"
        document = double "Document"

        signature_case = Egree::Case.new "Agreement", ["electronicId"]
        signature_case.add_party party
        signature_case.add_document document

        expect(Egree::Serializers::Party).to receive(:to_api_hash).with(party).and_return(party: "on")
        expect(Egree::Serializers::Document).to receive(:to_api_hash).with(document).and_return(document: "on")

        expect(Case.serialize(signature_case)).to eq JSON.pretty_generate({
          "CaseReferenceId" => signature_case.reference_id,
          "Name" => "Agreement",
          "Documents" => [{ document: "on" }],
          "Parties" => [{ party: "on" }],
          "AllowedSignatureTypes" => ["electronicId"]
        })
      end
    end
  end
end
