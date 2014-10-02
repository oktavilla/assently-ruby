module Egree
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
          postback_url: "CaseFinishedCallbackUrl",
          continue: ->(options) {
            CaseOptionsMapper.to_api options, name: "ContinueName", url: "ContinueUrl", auto: "ContinueAuto"
          }
        }
      end
    end
  end
end
