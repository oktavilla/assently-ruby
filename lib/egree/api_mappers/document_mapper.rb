require "egree/serializers/form_field"

module Egree
  module ApiMappers
    module DocumentMapper
      def self.to_api document
        {
          "Filename" => document.filename,
          "Data" => document.data,
          "ContentType" => document.content_type,
          "Size" => document.size,
          "FormFields" => document.form_fields.map { |form_field| Egree::Serializers::FormField.to_api_hash(form_field) }
        }
      end
    end
  end
end
