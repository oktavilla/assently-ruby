require "spec_helper"
require "egree/reference_id"

module Egree
  RSpec.describe ReferenceId do
    describe ".generate" do
      it ".returns a new reference id generated with SecureRandom" do
        expect(SecureRandom).to receive(:uuid).and_return "very-random"

        expect(ReferenceId.generate).to eq ReferenceId.new("very-random")
      end

      it "stores the id" do
        expect(ReferenceId.new("123").id).to eq "123"
      end

      describe "#to_s" do
        it "returns the id" do
          expect(ReferenceId.new(123).to_s).to eq "123"
        end
      end

      describe "#to_api_hash" do
        it "delegates to Serializers::ReferenceId" do
          reference_id = ReferenceId.new 123

          expect(reference_id.to_api_hash).to eq Serializers::ReferenceIdSerializer.to_api_hash(reference_id)
        end
      end
    end
  end
end
