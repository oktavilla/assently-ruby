require "spec_helper"
require "assently/case"

module Assently
  RSpec.describe Case do
    let :signature_case do
      Case.new "Agreement", Case.signature_types
    end

    it "requires a name" do
      expect(signature_case.name).to eq "Agreement"
    end

    describe "#id" do
      it "creates a unique id" do
        expect(Assently::IdGenerator).to receive(:generate).and_return "very-random"

        expect(signature_case.id).to eq "very-random"
      end

      it "does not change the id after created" do
        last_id = signature_case.id

        expect(signature_case.id).to eq last_id
      end

      it "does not share id between instances" do
        expect(signature_case.id).to_not eq Case.new("Agreement", Case.signature_types).id
      end

      it "can be overwritten on initialize" do
        signature_case = Case.new "Agreement", Case.signature_types, id: "my-special-id"

        expect(signature_case.id).to eq "my-special-id"
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
  end
end
