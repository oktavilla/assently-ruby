require "spec_helper"
require "assently/form_field"

module Assently
  RSpec.describe FormField do
    let :form_field do
      FormField.new "A name", "Some value"
    end

    specify "#name" do
      expect(form_field.name).to eq "A name"
    end

    specify "#value" do
      expect(form_field.value).to eq "Some value"
    end
  end
end
