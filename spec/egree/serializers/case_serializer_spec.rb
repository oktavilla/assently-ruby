require "spec_helper"

require "egree/case"
require "egree/serializers/case_serializer"

module Egree
  module Serializers
    RSpec.describe CaseSerializer do
      describe ".serialize" do
        it "maps the case to it's api representation and return it as json" do
          signature_case = double "Egree::Case"
          api_hash = { "The" => "Case" }

          expect(Egree::ApiMappers::CaseMapper).to receive(:to_api).with(signature_case).and_return api_hash

          expect(CaseSerializer.serialize(signature_case)).to eq JSON.pretty_generate(api_hash)
        end

        it "takes options for how to handle the user" do
          signature_case = double "Egree::Case"
          api_hash = { "The" => "Case" }
          options = { postback_url: "http://example.com" }
          options_hash = { "CaseFinishedCallbackUrl" => "http://example.com" }

          expect(Egree::ApiMappers::CaseMapper).to receive(:to_api).with(signature_case).and_return api_hash
          expect(Egree::ApiMappers::CaseOptionsMapper).to receive(:to_api).with(options).and_return options_hash

          expect(CaseSerializer.serialize(signature_case, options)).to eq JSON.pretty_generate(api_hash.merge(options_hash))
        end
      end
    end
  end
end
