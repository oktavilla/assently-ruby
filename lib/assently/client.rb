require "json"
require "faraday"

require "assently/serializers/case_serializer"

module Assently
  class Client
    attr_reader :api_key, :api_secret

    attr_accessor :environment

    def initialize api_key, api_secret, environment = :production
      @api_key = api_key
      @api_secret = api_secret
      self.environment = environment
    end

    def create_case signature_case, options = {}
      signature_case_json = Assently::Serializers::CaseSerializer.serialize signature_case, options

      post "/api/v2/createcase", signature_case_json
    end

    def send_case id
      post "/api/v2/sendcase", JSON.pretty_generate({ id: id })
    end

    def get_case id
      get "/api/v2/getcase", { id: id }
    end

    def post api_command, body = nil
      response = make_post api_command, body

      if response.success?
        SuccessResult.new response.body
      else
        ErrorResult.new response.body
      end
    end

    def get api_command, parameters = {}
      response = make_get api_command, parameters

      if response.success?
        SuccessResult.new response.body
      else
        ErrorResult.new response.body
      end
    end

    def host
      hosts.fetch(self.environment, hosts[:production])
    end

    def connection
      Faraday.new "https://#{host}" do |conn|
        conn.headers["Accept"] = "application/json"
        conn.basic_auth api_key, api_secret
        conn.adapter :net_http
      end
    end

    def headers
      connection.headers
    end

    private

    def make_post url, body
      connection.post do |request|
        request.url url
        request.headers["Content-Type"] = "application/json; charset=utf-8"
        request.body = body if body
      end
    end

    def make_get url, parameters
      connection.get url, parameters
    end

    def hosts
      {
        production: "app.assently.com",
        test: "test.assently.com"
      }
    end

    class SuccessResult
      attr_reader :raw

      def initialize response
        @raw = response
      end

      def response
        begin
          JSON.parse raw
        rescue JSON::ParserError
          raw
        end
      end

      def success?
        true
      end
    end

    class ErrorResult
      attr_reader :raw

      def initialize response
        @raw = response
      end

      def errors
        begin
          Array(JSON.parse(raw)["error"].values.join(" "))
        rescue JSON::ParserError
          raw
        end
      end

      def success?
        false
      end
    end
  end
end
