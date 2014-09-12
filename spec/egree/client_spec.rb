require "spec_helper"
require "egree/client"

RSpec.describe Egree::Client do
  let :client do
    Egree::Client.new "admin", "secret"
  end

  it "instantiates with username and password" do
    expect(client.username).to eq "admin"
    expect(client.password).to eq "secret"
  end

  describe "host" do
    it "defaults to the production environment" do
      expect(client.host).to eq "app.egree.com"
    end

    it "can be set to the test environment" do
      test_host = "test.underskrift.se"

      expect(Egree::Client.new("admin", "secret", :test).host).to eq test_host

      client = Egree::Client.new "admin", "secret"
      client.environment = :test

      expect(client.host).to eq test_host
    end
  end

  describe "#post" do
    it "it sends the json as the request body" do
      stub_request(:post, "https://admin:secret@app.egree.com/some/path").with({
        body: '{ "key": "value" }'
      })

      client.post "/some/path", '{ "key": "value" }'
    end

    describe "headers" do
      it "sets application/json with utf8 charset" do
        stub_request(:post, "https://admin:secret@app.egree.com/some/path").with({
          headers: { "content-type" => "application/json; charset=utf-8" }
        })

        client.post "/some/path", '{ "key": "value" }'
      end
    end

    describe "with a successful response" do
      before do
        stub_request(:post, "https://admin:secret@app.egree.com/some/path").to_return({
          status: 200,
          body: '{ "result": "Success" }'
        })
      end

      describe "result" do
        it "is successfull" do
          result = client.post "/some/path"

          expect(result.success?).to be true
        end

        it "parses the response json" do
          result = client.post "/some/path"

          expect(result.response).to eq("result" => "Success")
        end

        it "handles simple string bodies" do
          stub_request(:post, "https://admin:secret@app.egree.com/some/path").to_return({
            status: 200,
            body: "a string response"
          })

          result = client.post "/some/path"

          expect(result.response).to eq "a string response"
        end
      end
    end

    describe "with a error response" do
      before do
        stub_request(:post, "https://admin:secret@app.egree.com/some/path").to_return({
          status: 500,
          body: "<html><p>Error message</p><p>Another error</p></html>"
        })
      end

      it "returns a error result" do
        result = client.post "/some/path"

        expect(result.success?).to be false
      end

      it "parses the error messages from the html body" do
        result = client.post "/some/path"

        expect(result.errors).to eq [ "Error message", "Another error" ]
      end
    end
  end

  describe "#connection" do
    it "looks lika a faraday connection" do
      expect(client.connection).to be_kind_of Faraday::Connection
    end

    it "runs over https" do
      expect(client.connection.scheme).to eq "https"
    end

    it "points to the host" do
      expect(client.connection.host).to eq client.host
    end

    describe "authentication" do
      it "uses basic auth" do
        expect(client.headers["Authorization"]).to eq "Basic YWRtaW46c2VjcmV0"
      end
    end
  end
end
