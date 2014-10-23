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
      let :fixture_path do
        File.join(Dir.pwd, "spec/fixtures/agreement.pdf")
      end

      let :fixture_contents do
        File.read(fixture_path)
      end

      before do
        stub_request(:get, "http://example.com/files/remote_agreement.pdf").to_return({
          status: 200,
          body: fixture_contents
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
        expect(document.data).to eq Base64.encode64(fixture_contents)
      end

      describe "that is protected by basic authentication" do
        describe "with valid credentials" do
          let :url do
            "example.com/files/protected_file.pdf"
          end

          before do
            stub_request(:get, "test-user:secret@#{url}").to_return({
              status: 200,
              body: "the-body"
            })
          end

          it "returns the document" do
            document = Document.new("http://#{url}", username: "test-user", password: "secret")

            expect(document.data).to eq Base64.encode64("the-body")
          end
        end

        describe "with invalid credentials" do
          let :url do
            "http://example.com/files/protected_file.pdf"
          end

          before do
            stub_request(:get, url).to_return({
              status: [401, "Unauthorized"]
            })
          end

          it "throws a informative error if it cannot authenticate" do
            document = Document.new(url)

            expect{
              document.size
            }.to raise_error(Egree::CouldNotFetchDocumentError, /#{url}/)
          end
        end
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
