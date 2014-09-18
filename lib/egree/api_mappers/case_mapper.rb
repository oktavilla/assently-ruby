require "json"
require "egree/api_mappers/party_mapper"
require "egree/api_mappers/document_mapper"

module Egree
  module ApiMappers
    module CaseMapper
      def self.to_api signature_case
        {
          "Name" => signature_case.name,
          "Documents" => signature_case.documents.map { |document|
            Egree::ApiMappers::DocumentMapper.to_api(document)
          },
          "Parties" => signature_case.parties.map { |party|
            Egree::ApiMappers::PartyMapper.to_api(party)
          },
          "AllowedSignatureTypes" => signature_case.signature_types
        }.merge(signature_case.reference_id.to_api_hash)
      end
    end
  end
end
