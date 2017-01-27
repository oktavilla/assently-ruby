require "json"
require "assently/api_mappers/reference_id_mapper"

module Assently
  module Serializers
    module ReferenceIdSerializer
      def self.serialize reference_id
        JSON.pretty_generate Assently::ApiMappers::ReferenceIdMapper.to_api(reference_id)
      end
    end
  end
end

