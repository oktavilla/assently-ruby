if ENV["CI"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "dotenv"
require "webmock/rspec"
require "vcr"
require "uri"

Dotenv.load

WebMock.disable_net_connect! allow: "codeclimate.com"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<EGREE_USERNAME>") { URI.encode_www_form_component ENV["EGREE_USERNAME"] }
  config.filter_sensitive_data("<EGREE_PASSWORD>") { URI.encode_www_form_component ENV["EGREE_PASSWORD"] }

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
