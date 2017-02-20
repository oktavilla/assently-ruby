module Assently
  class CaseEventSubscription
    attr_reader :events, :url

    def self.events
      [ "created", "sent", "recalled", "finished", "rejected", "expired", "deleted", "signatureadded", "approvalrequested", "reminded" ]
    end

    def initialize(events, url)
      self.events = events
      @url = url
    end

    def events= events
      unknown_events = events - CaseEventSubscription.events
      if unknown_events.any?
        raise unknown_event_error(unknown_events)
      end

      @events = events
    end

    private

    def unknown_event_error events
      ArgumentError.new("Unknown events: #{events.join(", ")}. Valid events are: #{CaseEventSubscription.events.join(", ")}")
    end
  end
end
