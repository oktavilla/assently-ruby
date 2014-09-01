require "spec_helper"

require "egree/serializers/form_field"
require "egree/form_field"

module Egree
  module Serializers
    RSpec.describe FormField do
      describe ".serialize" do
        it "returns a json string of the api hash" do
          form_field = double "FormField"

          expect(FormField).to receive(:to_api_hash).with(form_field).and_return(form_field: "hash")

          expect(FormField.serialize(form_field)).to eq JSON.pretty_generate(form_field: "hash")
        end
      end

      specify ".to_api_hash" do
        form_field = Egree::FormField.new "The name", "The Value"

        expect(FormField.to_api_hash(form_field)).to eq({
          "Name" => "The name",
          "Value" => "The Value"
        })
      end
    end
  end
end
