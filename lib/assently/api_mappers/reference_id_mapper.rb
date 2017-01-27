module Assently
  module ApiMappers
    module ReferenceIdMapper
      def self.to_api reference_id
        { "CaseReferenceId" => reference_id.to_s }
      end
    end
  end
end
