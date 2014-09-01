require "spec_helper"
require "egree/serializers/document"

module Egree
  module Serializers
    RSpec.describe Document do
      describe ".serialize" do
        it "returns a json string of the api hash" do
          document = double "Document"

          expect(Document).to receive(:to_api_hash).with(document).and_return(document: "hash")

          expect(Document.serialize(document)).to eq JSON.pretty_generate(document: "hash")
        end
      end

      describe ".to_api_hash" do
        it "creates a hash that matches the api's expected format" do
          form_field = double "FormField"

          document = double("Document", {
            filename: "agreement.pdf",
            size: 123,
            data: "encoded-data",
            content_type: "application/pdf",
            form_fields: [form_field]
          })

          expect(Egree::Serializers::FormField).to receive(:to_api_hash).with(form_field).and_return({
            name: "FieldKey",
            value: "FieldValue"
          })

          expect(Document.to_api_hash(document)).to eq({
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
