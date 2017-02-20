module Assently
  module ApiMappers
    module FormFieldMapper
      def self.to_api form_field
        {
          "Name" => form_field.name,
          "Value" => form_field.value
        }
      end
    end
  end
end
