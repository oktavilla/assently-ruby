require "securerandom"
require "egree/serializers/reference_id_serializer"

module Egree
  class ReferenceId
    include Comparable

    def self.generate
      new SecureRandom.uuid
    end

    attr_reader :id

    def initialize id
      @id = id
    end

    def to_s
      id.to_s
    end

    def to_json
      Serializers::ReferenceIdSerializer.serialize self
    end

    def to_api_hash
      Serializers::ReferenceIdSerializer.to_api_hash self
    end

    def <=> other
      other.is_a?(self.class) && self.id <=> other.id
    end
  end
end
