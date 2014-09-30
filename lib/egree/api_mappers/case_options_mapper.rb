module Egree
  module ApiMappers
    module CaseOptionsMapper
      def self.to_api options = {}, key_map = self.key_map
        options.reduce({}) do |api_hash, (k, v)|
          api_hash.merge(self.map_key(k, v, key_map)) if key_map.key?(k)
        end || {}
      end

      private

      def self.map_key key, value, key_map = self.key_map
        mapper = key_map[key]

        if mapper.respond_to?(:call)
          mapper.call value
        else
          { mapper => value }
        end
      end

      def self.key_map
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
