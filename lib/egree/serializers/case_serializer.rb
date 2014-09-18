require "json"
require "egree/api_mappers/case_mapper"

module Egree
  module Serializers
    module CaseSerializer
      def self.serialize signature_case
        JSON.pretty_generate Egree::ApiMappers::CaseMapper.to_api(signature_case)
      end
    end
  end
end
