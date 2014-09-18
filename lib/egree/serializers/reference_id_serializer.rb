require "json"

require "egree/api_mappers/reference_id_mapper"

module Egree
  module Serializers
    module ReferenceIdSerializer
      def self.serialize reference_id
        JSON.pretty_generate Egree::ApiMappers::ReferenceIdMapper.to_api(reference_id)
      end

      def self.to_api_hash reference_id
        {
          "CaseReferenceId" => reference_id.to_s
        }
      end
    end
  end
end

