require "spec_helper"

require "assently/case"
require "assently/serializers/case_serializer"

module Assently
  module Serializers
    RSpec.describe CaseSerializer do
      describe ".serialize" do
        it "maps the case to a api representation and return it as json" do
          signature_case = double "Assently::Case"
          api_hash = { "The" => "Case" }

          expect(Assently::ApiMappers::CaseMapper).to receive(:to_api).with(signature_case).and_return api_hash

          expect(CaseSerializer.serialize(signature_case)).to eq JSON.pretty_generate(api_hash)
        end

        it "maps event subscription" do
          api_hash = { "The" => "Case" }
          signature_case = double "Assently::Case"
          event_subscription = double "Assently::CaseEventSubscription", events: ["finished", "rejected"], url: "http://example.com"
          options = { event_callback: event_subscription }
          options_hash = {
            "EventCallback" => {
              "Events" => ["finished", "rejected"],
              "Url" => "http://example.com"
            }
          }

          expect(Assently::ApiMappers::CaseMapper).to receive(:to_api).with(signature_case).and_return api_hash
          expect(Assently::ApiMappers::CaseOptionsMapper).to receive(:to_api).with(options).and_return options_hash

          expect(CaseSerializer.serialize(signature_case, options)).to eq JSON.pretty_generate(api_hash.merge(options_hash))
        end
      end
    end
  end
end
