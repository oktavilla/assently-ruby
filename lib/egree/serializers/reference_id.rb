require "json"

module Egree
  module Serializers
    module ReferenceId
      def self.serialize reference_id
        JSON.pretty_generate to_api_hash(reference_id)
      end

      def self.to_api_hash reference_id
        {
          "CaseReferenceId" => reference_id.to_s
        }
      end
    end
  end
end

