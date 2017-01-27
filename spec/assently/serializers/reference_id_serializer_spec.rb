require "spec_helper"

require "assently/serializers/reference_id_serializer"
require "assently/reference_id"

module Assently
  module Serializers
    RSpec.describe ReferenceIdSerializer do
      describe ".serialize" do
        it "returns a json string of the api hash" do
          reference_id = double "ReferenceId"

          expect(Assently::ApiMappers::ReferenceIdMapper).to receive(:to_api).with(reference_id).and_return(reference_id: "value")

          expect(ReferenceIdSerializer.serialize(reference_id)).to eq JSON.pretty_generate(reference_id: "value")
        end
      end
    end
  end
end
