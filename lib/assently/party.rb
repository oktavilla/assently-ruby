module Assently
  class Party
    attr_accessor :name, :email
    attr_reader :social_security_number

    def self.new_with_attributes attributes = {}
      party = self.new

      attributes.each do |name, value|
        assignment_method_name = "#{name}="
        party.public_send(assignment_method_name, value) if party.respond_to?(assignment_method_name)
      end

      party
    end

    def social_security_number= social_security_number
      @social_security_number = social_security_number.to_s.gsub(/\D/, "")
    end
  end
end
