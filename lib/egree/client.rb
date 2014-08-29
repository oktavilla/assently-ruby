require "faraday"

module Egree
  class Client
    attr_reader :username, :password

    attr_accessor :environment

    def initialize username, password, environment = :production
      @username = username
      @password = password
      self.environment = environment
    end

    def post url, body
      connection.post do |request|
        request.url url
        request.headers["Content-Type"] = "application/json; charset=utf-8"
        request.body = body
      end
    end

    def host
      hosts.fetch(self.environment, hosts[:production])
    end

    def connection
      Faraday.new "https://#{host}" do |conn|
        conn.adapter :net_http
        conn.basic_auth username, password
      end
    end

    def headers
      connection.headers
    end

    private

    def hosts
      {
        production: "app.egree.com",
        test: "test.underskrift.se"
      }
    end
  end
end
