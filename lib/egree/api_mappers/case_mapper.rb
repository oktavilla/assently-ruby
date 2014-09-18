require "json"
require "egree/serializers/party"
require "egree/serializers/document"

module Egree
  module ApiMappers
    module CaseMapper
      def self.to_api signature_case
        {
          "Name" => signature_case.name,
          "Documents" => signature_case.documents.map { |document| Egree::Serializers::Document.to_api_hash(document) },
          "Parties" => signature_case.parties.map { |party| Egree::Serializers::Party.to_api_hash(party) },
          "AllowedSignatureTypes" => signature_case.signature_types
        }.merge(signature_case.reference_id.to_api_hash)
      end
    end
  end
end
