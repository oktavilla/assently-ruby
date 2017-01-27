require "spec_helper"
require "assently/id_generator"

module Assently
  RSpec.describe IdGenerator do
    describe ".generate" do
      it ".returns a new id generated with SecureRandom" do
        expect(SecureRandom).to receive(:uuid).and_return "very-random"
        expect(IdGenerator.generate).to eq "very-random"
      end
    end
  end
end
