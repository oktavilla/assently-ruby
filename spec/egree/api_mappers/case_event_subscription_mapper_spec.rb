require "spec_helper"
require "egree/api_mappers/case_event_subscription_mapper"

module Egree
  module ApiMappers
    RSpec.describe CaseEventSubscriptionMapper do
      describe ".to_api" do
        it "creates a hash that matches the api's expected format" do
          case_event_subscription = double("CaseEventSubscription", {
            events: ["created", "sent"],
            url: "http://example.com"
          })

          expect(CaseEventSubscriptionMapper.to_api(case_event_subscription)).to eq({
            "Events" => ["created", "sent"],
            "Url" => "http://example.com"
          })
        end
      end
    end
  end
end
