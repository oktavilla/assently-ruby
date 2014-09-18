require "spec_helper"
require "egree/api_mappers/document_mapper"

module Egree
  module ApiMappers
    RSpec.describe DocumentMapper do
      describe ".to_api" do
        it "creates a hash that matches the api's expected format" do
          form_field = double "FormField"

          document = double("Document", {
            filename: "agreement.pdf",
            size: 123,
            data: "encoded-data",
            content_type: "application/pdf",
            form_fields: [form_field]
          })

          expect(Egree::ApiMappers::FormFieldMapper).to receive(:to_api).with(form_field).and_return({
            name: "FieldKey",
            value: "FieldValue"
          })

          expect(DocumentMapper.to_api(document)).to eq({
            "Filename" => "agreement.pdf",
            "Data" => "encoded-data",
            "ContentType" => "application/pdf",
            "Size" => 123,
            "FormFields" => [{ name: "FieldKey", value: "FieldValue" }]
          })
        end
      end
    end
  end
end
