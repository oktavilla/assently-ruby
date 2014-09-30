require "spec_helper"
require "egree/api_mappers/case_options_mapper"

module Egree
  module ApiMappers
    RSpec.describe CaseOptionsMapper do
      describe "#to_api" do
        it "translates postback_url to CaseFinishedCallbackUrl" do
          expect(CaseOptionsMapper.to_api(postback_url: "http://example.com")).to eq({
            "CaseFinishedCallbackUrl" => "http://example.com"
          })
        end

        describe "continue_to" do
          it "translates name" do
            options = { continue: { name: "The label" } }

            expect(CaseOptionsMapper.to_api(options)).to eq({
              "ContinueName" => "The label"
            })
          end

          it "translates url" do
            options = { continue: { url: "http://example.com/where-to-go" } }

            expect(CaseOptionsMapper.to_api(options)).to eq({
              "ContinueUrl" => "http://example.com/where-to-go"
            })
          end

          it "translates auto" do
            options = { continue: { auto: true } }

            expect(CaseOptionsMapper.to_api(options)).to eq({
              "ContinueAuto" => true
            })
          end
        end

        it "ignores unknown keys" do
          expect(CaseOptionsMapper.to_api(unknown: "Some value")).to eq({})
        end
      end
    end
  end
end
