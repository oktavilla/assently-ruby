require "spec_helper"

require "egree/api_mappers/reference_id_mapper"
require "egree/reference_id"

module Egree
  module ApiMappers
    RSpec.describe ReferenceIdMapper do
      specify "#to_api" do
        reference_id = Egree::ReferenceId.new 123

        expect(ReferenceIdMapper.to_api(reference_id)).to eq({
          "CaseReferenceId" => "123"
        })
      end
    end
  end
end
