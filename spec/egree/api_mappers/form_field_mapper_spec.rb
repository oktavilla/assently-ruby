require "spec_helper"

require "egree/api_mappers/form_field_mapper"
require "egree/form_field"

module Egree
  module ApiMappers
    RSpec.describe FormFieldMapper do
      specify ".to_api" do
        form_field = Egree::FormField.new "The name", "The Value"

        expect(FormFieldMapper.to_api(form_field)).to eq({
          "Name" => "The name",
          "Value" => "The Value"
        })
      end
    end
  end
end
