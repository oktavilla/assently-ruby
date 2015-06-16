module Egree
  class CaseEventSubscription
    attr_reader :events, :url

    def initialize(events, url)
      @events = events
      @url = url
    end
  end
end
