require "spec_helper"

require "assently/api_mappers/form_field_mapper"
require "assently/form_field"

module Assently
  module ApiMappers
    RSpec.describe FormFieldMapper do
      specify ".to_api" do
        form_field = Assently::FormField.new "The name", "The Value"

        expect(FormFieldMapper.to_api(form_field)).to eq({
          "Name" => "The name",
          "Value" => "The Value"
        })
      end
    end
  end
end
