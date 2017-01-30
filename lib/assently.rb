require "assently/case"
require "assently/client"
require "assently/document"
require "assently/form_field"
require "assently/party"
require "assently/id_generator"
require "assently/version"
require "assently/case_event_subscription"

module Assently
  def self.client api_key, api_secret, environment = :production
    Client.new api_key, api_secret, environment
  end
end
