if ENV["CI"]
  require "simplecov"
  SimpleCov.start
end

require "dotenv"
require "webmock/rspec"
require "vcr"
require "uri"
require "pry"

Dotenv.load

WebMock.disable_net_connect! allow: "codeclimate.com"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<ASSENTLY_API_AUTH_HEADER>") { Base64.strict_encode64 "#{ENV["ASSENTLY_API_KEY"]}:#{ENV["ASSENTLY_API_SECRET"]}" }

  config.allow_http_connections_when_no_cassette = true
  config.ignore_hosts "codeclimate.com"
end

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
