require "egree/case"
require "egree/client"
require "egree/document"
require "egree/form_field"
require "egree/party"
require "egree/reference_id"
require "egree/version"

module Egree
  def self.client username, password, environment = :production
    Client.new username, password, environment
  end
end
