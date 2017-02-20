require "spec_helper"
require "assently/case_event_subscription"

module Assently
  RSpec.describe CaseEventSubscription do
    describe "events" do
      it "accepts a valid event" do
        case_event_subscription = CaseEventSubscription.new([CaseEventSubscription.events.first], 'http://test.com')

        expect(case_event_subscription.events.first).to eq(CaseEventSubscription.events.first)
      end

      it "throws an error if it is an unknown event" do |variable|
        expect{ CaseEventSubscription.new(['invalid_event'], 'http://test.com') }.to raise_error(ArgumentError)
      end
    end
  end
end
