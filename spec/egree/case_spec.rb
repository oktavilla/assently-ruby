require "spec_helper"
require "egree/case"

module Egree
  RSpec.describe Case do
    it "requires a name" do
      signature_case = Case.new "Agreement", Case.signature_types

      expect(signature_case.name).to eq "Agreement"
    end

    describe "signature types" do
      it "requires at least one valid signature type" do
        signature_case = Case.new "Agreement", Case.signature_types.first

        expect(signature_case.signature_types).to eq [ Case.signature_types.first ]
      end

      it "throws an error if it is an unknown signature type" do
        expect{ Case.new("Agreement", "unknown type") }.to raise_error(ArgumentError)
      end
    end

    it "adds a party" do
      signature_case = Case.new "Agreement", Case.signature_types

      party = double "Party"
      signature_case.add_party party

      expect(signature_case.parties).to eq [party]
    end

    it "adds a document" do
      signature_case = Case.new "Agreement", Case.signature_types

      document = double "Document"
      signature_case.add_document document

      expect(signature_case.documents).to eq [document]
    end
  end
end
