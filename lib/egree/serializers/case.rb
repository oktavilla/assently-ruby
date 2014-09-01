require "json"
require "egree/serializers/party"
require "egree/serializers/document"

module Egree
  module Serializers
    module Case
      def self.serialize signature_case
        JSON.pretty_generate to_api_hash(signature_case)
      end

      def self.to_api_hash signature_case
        {
          "CaseReferenceId" => signature_case.reference_id,
          "Name" => signature_case.name,
          "Documents" => signature_case.documents.map { |document| Document.to_api_hash(document) },
          "Parties" => signature_case.parties.map { |party| Party.to_api_hash(party) },
          "AllowedSignatureTypes" => signature_case.signature_types
        }
      end
    end
  end
end
