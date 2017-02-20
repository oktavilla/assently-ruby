module Assently
  module ApiMappers
    module CaseEventSubscriptionMapper
      def self.to_api case_event_subscription
        {
          "Events" => case_event_subscription.events,
          "Url" => case_event_subscription.url
        }
      end
    end
  end
end
