require "spec_helper"
require "egree/case"

module Egree
  RSpec.describe Case do
    let :signature_case do
      Case.new "Agreement", Case.signature_types
    end

    it "requires a name" do
      expect(signature_case.name).to eq "Agreement"
    end

    specify ".generate_reference_id" do
      expect(Egree::ReferenceId).to receive(:generate).and_return "very-random"

      expect(Case.generate_reference_id).to eq "very-random"
    end

    describe "#reference_id" do
      it "creates a unique reference_id" do
        expect(Case).to receive(:generate_reference_id).and_return "very-random"

        expect(signature_case.reference_id).to eq "very-random"
      end

      it "does not change the reference_id after created" do
        last_id = signature_case.reference_id

        expect(signature_case.reference_id).to eq last_id
      end

      it "does not share reference_id between instances" do
        expect(signature_case.reference_id).to_not eq Case.new("Agreement", Case.signature_types).reference_id
      end
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

    describe "#to_json" do
      it "uses Serializers::Case" do
        expect(signature_case.to_json).to eq Serializers::Case.serialize(signature_case)
      end
    end
  end
end
