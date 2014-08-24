require "egree/version"
require "egree/client"

module Egree
  def self.client *args
    Client.new *args
  end
end
