require "spec_helper"
require "assently/api_mappers/case_options_mapper"

module Assently
  module ApiMappers
    RSpec.describe CaseOptionsMapper do
      describe "#to_api" do
        it "translates postback_url to CaseFinishedCallbackUrl" do
          expect(CaseOptionsMapper.to_api(postback_url: "http://example.com")).to eq({
            "CaseFinishedCallbackUrl" => "http://example.com"
          })
        end

        it "translates cancel_url to CancelUrl" do
          expect(CaseOptionsMapper.to_api(cancel_url: "http://example.com")).to eq({
            "CancelUrl" => "http://example.com"
          })
        end

        it "translates procedure to Procedure" do
          expect(CaseOptionsMapper.to_api(procedure: "form")).to eq({
            "Procedure" => "form"
          })
        end

        describe "locale" do
          it "translates locale to Culture allowing sv, fi and en" do
            { "sv" => "sv-SE", "fi" => "fi-FI", "en" => "en-US" }.each do |key, locale|
              expect(CaseOptionsMapper.to_api(locale: key)).to eq({
                "Culture" => locale
              })
            end
          end

          it "raises an InvalidCaseOptionError for unkown locales" do
            expect{ CaseOptionsMapper.to_api(locale: "unknown") }.to raise_error{
              Assently::InvalidCaseOptionError
            }
          end
        end

        describe "continue" do
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
          expect(CaseOptionsMapper.to_api({
            postback_url: "http://example.com",
            unknown: "Some value"
          })).to eq({
            "CaseFinishedCallbackUrl" => "http://example.com"
          })
        end
      end
    end
  end
end
