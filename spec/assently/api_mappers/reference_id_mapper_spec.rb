require "spec_helper"

require "assently/api_mappers/reference_id_mapper"
require "assently/reference_id"

module Assently
  module ApiMappers
    RSpec.describe ReferenceIdMapper do
      specify "#to_api" do
        reference_id = Assently::ReferenceId.new 123

        expect(ReferenceIdMapper.to_api(reference_id)).to eq({
          "CaseReferenceId" => "123"
        })
      end
    end
  end
end
