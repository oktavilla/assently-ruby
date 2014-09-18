require "json"
require "faraday"

require "egree/serializers/case_serializer"

module Egree
  class Client
    attr_reader :username, :password

    attr_accessor :environment

    def initialize username, password, environment = :production
      @username = username
      @password = password
      self.environment = environment
    end

    def create_case signature_case
      signature_case_json = Egree::Serializers::CaseSerializer.serialize signature_case
      post "/apiv1/createcasecommand", signature_case_json
    end

    def get_case_url reference_id
      post "/apiv1/getviewcaseurlquery", reference_id.to_json
    end

    def post api_command, body = nil
      response = make_post api_command, body

      if response.success?
        SuccessResult.new parse_success_response(response.body)
      else
        ErrorResult.new parse_error_response(response.body)
      end
    end

    def host
      hosts.fetch(self.environment, hosts[:production])
    end

    def connection
      Faraday.new "https://#{host}" do |conn|
        conn.adapter :net_http
        conn.headers["Accept"] = "application/json"
        conn.basic_auth username, password
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

    def parse_success_response body
      begin
        JSON.parse body
      rescue JSON::ParserError
        body
      end
    end

    def parse_error_response body
      body.scan(/<p>(.*?)<\/p>/).flatten
    end

    def hosts
      {
        production: "app.egree.com",
        test: "test.underskrift.se"
      }
    end

    class SuccessResult
      attr_reader :response

      def initialize response
        @response = response
      end

      def success?
        true
      end
    end

    class ErrorResult
      attr_reader :errors

      def initialize errors = []
        @errors = Array(errors)
      end

      def success?
        false
      end
    end
  end
end
