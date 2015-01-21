require "json"
require "faraday"

require "egree/serializers/case_serializer"
require "egree/serializers/reference_id_serializer"

module Egree
  class Client
    attr_reader :username, :password

    attr_accessor :environment

    def initialize username, password, environment = :production
      @username = username
      @password = password
      self.environment = environment
    end

    def create_case signature_case, options = {}
      signature_case_json = Egree::Serializers::CaseSerializer.serialize signature_case, options
      post "/apiv1/createcasecommand", signature_case_json
    end

    def get_case_url signature_case
      reference_id = signature_case.respond_to?(:reference_id) ? signature_case.reference_id : signature_case.to_s
      reference_id_json = Egree::Serializers::ReferenceIdSerializer.serialize reference_id

      post "/apiv1/getviewcaseurlquery", reference_id_json
    end

    def post api_command, body = nil
      response = make_post api_command, body

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
        conn.basic_auth username, password
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

    def hosts
      {
        production: "app.egree.com",
        test: "test.egree.com"
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
