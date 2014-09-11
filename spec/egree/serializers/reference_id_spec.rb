require "spec_helper"

require "egree/serializers/reference_id"
require "egree/reference_id"

module Egree
  module Serializers
    RSpec.describe ReferenceId do
      describe ".serialize" do
        it "returns a json string of the api hash" do
          reference_id = double "ReferenceId"

          expect(ReferenceId).to receive(:to_api_hash).with(reference_id).and_return(reference_id: "value")

          expect(ReferenceId.serialize(reference_id)).to eq JSON.pretty_generate(reference_id: "value")
        end
      end

      specify ".to_api_hash" do
        reference_id = Egree::ReferenceId.new 123

        expect(ReferenceId.to_api_hash(reference_id)).to eq({
          "CaseReferenceId" => "123"
        })
      end
    end
  end
end
