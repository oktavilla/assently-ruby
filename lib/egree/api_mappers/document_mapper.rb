require "egree/api_mappers/form_field_mapper"

module Egree
  module ApiMappers
    module DocumentMapper
      def self.to_api document
        {
          "Filename" => document.filename,
          "Data" => document.data,
          "ContentType" => document.content_type,
          "Size" => document.size,
          "FormFields" => document.form_fields.map { |form_field|
            Egree::ApiMappers::FormFieldMapper.to_api(form_field)
          }
        }
      end
    end
  end
end
