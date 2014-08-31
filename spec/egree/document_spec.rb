require "spec_helper"
require "egree/document"

module Egree
  RSpec.describe Document do
    let :fixture_path do
      File.join(Dir.pwd, "spec/fixtures/agreement.pdf")
    end

    describe "with a local file" do
      let :document do
        Document.new fixture_path
      end

      specify "#filename" do
        expect(document.filename).to eq "agreement.pdf"
      end

      specify "#size" do
        expect(document.size).to eq 6925
      end

      specify "#content_type" do
        expect(document.content_type).to eq "application/pdf"
      end

      it "has the file data encoded as base64" do
        expect(document.data).to eq Base64.encode64(File.open(fixture_path).read)
      end
    end

    describe "#with an url" do
      before do
        fixture_path = File.join(Dir.pwd, "spec/fixtures/agreement.pdf")

        stub_request(:get, "http://example.com/files/remote_agreement.pdf").to_return({
          status: 200,
          body: File.read(fixture_path)
        })
      end

      let :document do
        Document.new "http://example.com/files/remote_agreement.pdf"
      end

      specify "#filename" do
        expect(document.filename).to eq "remote_agreement.pdf"
      end

      specify "#size" do
        expect(document.size).to eq 6925
      end

      specify "#content_type" do
        expect(document.content_type).to eq "application/pdf"
      end

      it "has the file data encoded as base64" do
        fixture_path = File.join(Dir.pwd, "spec/fixtures/agreement.pdf")
        expect(document.data).to eq Base64.encode64(File.open(fixture_path).read)
      end
    end

    it "adds form fields"  do
      document = Document.new fixture_path
      form_field = double "FormField", name: "FieldName", value: "Some Value"

      document.add_form_field form_field

      expect(document.form_fields).to eq [form_field]
    end
  end
end
