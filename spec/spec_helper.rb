if ENV["CI"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "dotenv"
require "webmock/rspec"
require "vcr"
require "uri"

Dotenv.load

WebMock.disable_net_connect!

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.filter_sensitive_data("<EGREE_USERNAME>") { URI.encode_www_form_component ENV["EGREE_USERNAME"] }
  c.filter_sensitive_data("<EGREE_PASSWORD>") { URI.encode_www_form_component ENV["EGREE_PASSWORD"] }
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
