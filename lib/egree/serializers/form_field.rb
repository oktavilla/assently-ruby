module Egree
  module Serializers
    module FormField
      def self.serialize form_field
        JSON.pretty_generate to_api_hash(form_field)
      end

      def self.to_api_hash form_field
        {
          "Name" => form_field.name,
          "Value" => form_field.value
        }
      end
    end
  end
end
