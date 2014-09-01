require "egree/serializers/form_field"

module Egree
  module Serializers
    module Document
      def self.serialize document
        JSON.pretty_generate to_api_hash(document)
      end

      def self.to_api_hash document
        {
          "Filename" => document.filename,
          "Data" => document.data,
          "ContentType" => document.content_type,
          "Size" => document.size,
          "FormFields" => document.form_fields.map { |form_field| FormField.to_api_hash(form_field) }
        }
      end
    end
  end
end
