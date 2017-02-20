require "securerandom"

module Assently
  class IdGenerator

    def self.generate
      SecureRandom.uuid
    end
  end
end
