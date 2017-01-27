require "assently/case"
require "assently/client"
require "assently/document"
require "assently/form_field"
require "assently/party"
require "assently/reference_id"
require "assently/version"

module Assently
  def self.client username, password, environment = :production
    Client.new username, password, environment
  end
end
