module Egree
  module ApiMappers
    module PartyMapper
      def self.to_api party
        {
          "Name" => party.name,
          "EmailAddress" => party.email,
          "SocialSecurityNumber" => party.social_security_number
        }
      end
    end
  end
end
