require "assently/api_mappers/case_event_subscription_mapper"

module Assently
  class InvalidCaseOptionError < ArgumentError; end

  module ApiMappers
    module CaseOptionsMapper
      def self.to_api options = {}, mappers = self.mappers
        options.reduce({}) do |api_hash, (client_key, value)|
          if mappers.key?(client_key)
            api_hash.merge(self.map(client_key, value, mappers))
          else
            api_hash
          end
        end || {}
      end

      private

      LOCALES = ->(locale) {
        {
          "sv" => "sv-SE",
          "fi" => "fi-FI",
          "en" => "en-US"
        }.fetch(locale) { raise Assently::InvalidCaseOptionError.new("Unknown locale: #{locale}") }
      }

      def self.map client_key, value, mappers = self.mappers
        mapper = mappers[client_key]

        if mapper.respond_to?(:call)
          mapper.call value
        else
          { mapper => value }
        end
      end

      def self.mappers
        {
          name_alias: "NameAlias",
          agent_username: "AgentUsername",
          visibility: "Visibility",
          description: "Description",
          send_sign_request_email_to_parties: "SendSignRequestEmailToParties",
          send_finish_email_to_creator: "SendFinishEmailToCreator",
          send_finish_email_to_parties: "SendFinishEmailToParties",
          send_recall_email_to_parties: "SendRecallEmailToParties",
          cancel_url: "CancelUrl",
          procedure: "Procedure",
          locale: ->(value) {
            { "Culture" => LOCALES.call(value) }
          },
          continue: ->(options) {
            CaseOptionsMapper.to_api options, name: "ContinueName", url: "ContinueUrl", auto: "ContinueAuto"
          },
          sign_in_sequence: "SignInSequence",
          identity_check: "IdentityCheck",
          merge_on_send: "MergeOnSend",
          expire_after_days: "ExpireAfterDays",
          expire_on: ->(value) {
            { "ExpireOn" => value.iso8601 }
          },
          remind_ander_days: "RemindAfterDays",
          template_id: "TemplateId",
          is_editable: "IsEditable",
          event_callback: ->(value) {
            { "EventCallback" => CaseEventSubscriptionMapper.to_api(value) }
          },
          meta_data: "MetaData"
        }
      end
    end
  end
end
