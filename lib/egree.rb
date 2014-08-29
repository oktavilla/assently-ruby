require "egree/version"
require "egree/client"

module Egree
  def self.client username, password, environment = :production
    Client.new username, password, environment
  end
end
