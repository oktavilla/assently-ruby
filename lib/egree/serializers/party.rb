module Egree
  module Serializers
    module Party
      def self.serialize party
        JSON.pretty_generate to_api_hash(party)
      end

      def self.to_api_hash party
        {
          "Name" => party.name,
          "EmailAddress" => party.email,
          "SocialSecurityNumber" => party.social_security_number
        }
      end
    end
  end
end
