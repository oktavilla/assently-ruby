module Egree
  class Client
    attr_reader :username, :password

    def initialize username: ENV["EGREE_USERNAME"], password: ENV["EGREE_PASSWORD"]
      @username = username
      @password = password
    end
  end
end
