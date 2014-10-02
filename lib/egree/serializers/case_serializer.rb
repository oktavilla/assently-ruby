require "json"
require "egree/api_mappers/case_mapper"

module Egree
  module Serializers
    module CaseSerializer
      def self.serialize signature_case, options = {}
        signature_case_api_hash = Egree::ApiMappers::CaseMapper.to_api signature_case
        options_api_hash = Egree::ApiMappers::CaseOptionsMapper.to_api options
        JSON.pretty_generate signature_case_api_hash.merge(options_api_hash)
      end
    end
  end
end
