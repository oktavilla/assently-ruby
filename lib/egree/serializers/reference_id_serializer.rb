require "json"
require "egree/api_mappers/reference_id_mapper"

module Egree
  module Serializers
    module ReferenceIdSerializer
      def self.serialize reference_id
        JSON.pretty_generate Egree::ApiMappers::ReferenceIdMapper.to_api(reference_id)
      end
    end
  end
end

