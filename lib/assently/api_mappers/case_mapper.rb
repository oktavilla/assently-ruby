require "json"
require "assently/api_mappers/party_mapper"
require "assently/api_mappers/document_mapper"

module Assently
  module ApiMappers
    module CaseMapper
      def self.to_api signature_case
        {
          "Id" => signature_case.id,
          "Name" => signature_case.name,
          "Documents" => signature_case.documents.map { |document|
            Assently::ApiMappers::DocumentMapper.to_api(document)
          },
          "Parties" => signature_case.parties.map { |party|
            Assently::ApiMappers::PartyMapper.to_api(party)
          },
          "AllowedSignatureTypes" => signature_case.signature_types
        }
      end
    end
  end
end
