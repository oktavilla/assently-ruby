[![Build Status](https://travis-ci.org/Oktavilla/assently-ruby.svg?branch=master)](https://travis-ci.org/Oktavilla/assently-ruby)
[![Code Climate](https://codeclimate.com/github/Oktavilla/assently-ruby/badges/gpa.svg)](https://codeclimate.com/github/Oktavilla/assently-ruby)
[![Test Coverage](https://codeclimate.com/github/Oktavilla/assently-ruby/badges/coverage.svg)](https://codeclimate.com/github/Oktavilla/assently-ruby)
[![Gem Version](https://badge.fury.io/rb/assently.svg)](http://badge.fury.io/rb/assently)

# Assently API Client

Ruby client for the [Assently API v2](https://assently.com/). Check out [the official API documentation here](https://app.assently.com/api/).

### Supported API calls 

| API call   | Supported |
|----------|:-------------:|
| `createcase` | ✔️ |
| `sendcase` | ✔️|
| `getcase` | ✔️|
| `createcasefromtemplate ` | |
| `updatecase ` | |
| `remindcase ` | |
| `deletecase ` | |
| `recallcase ` | |
| `findcases ` | |
| `findtemplates ` | |
| `getdocumentdata ` | |
| `createagent ` | |
| `createssoticket ` | |

Missing something? Contributions are very welcome! 😘 

## Installation

Include the gem in your `Gemfile`:

```ruby
gem "assently"
```

## Usage

### Environment

When creating a client instance you can choose to use either Assently's `production` (default when not specified) or `test` environment. The host `app.assently.com` is used for production and `test.assently.com` is used for test when constructing the API commands. Test environment is specified like this:

```ruby
Assently.client ENV["ASSENTLY_API_KEY"], ENV["ASSENTLY_API_SECRET"], :test
```

### Creating a case

```ruby
assently = Assently.client assently_api_key, assently_api_secret

case_id = SecureRandom.uuid

signature_case = Assently::Case.new "Agreement", ["electronicid"], id: case_id
signature_case.add_party Assently::Party.new_with_attributes({
  name: "First Last",
  email: "name@example.com",
  social_security_number: "1234567890"
})
signature_case.add_document Assently::Document.new "/some/path/file.pdf"

event_subscription = Assently::CaseEventSubscription.new ["finished", "expired"], "https://example.com/my-endpoint"

result = assently.create_case(signature_case, {
  # Callback for document events
  event_callback: event_subscription,
  # User ends up here after finishing the signing process
  continue: {
    url: "http://example.com/user-endpoint",
    auto: true
  },
  # User ends up here when cancelling, at the moment there is no cancel callback
  cancel_url: "http://example.com/user-canceled"
})

if result.success?
  puts "#{signature_case.id} was created."
else 
  puts "There was some issues with the case"
  result.errors.each do |error|
    puts error
  end
end
```

### Making a case available for signing

```ruby
assently = Assently.client API_KEY, API_SECRET
result = assently.get_case case_id

if result.success?
  assently.send_case case_id
  
  signing_case = assently.get_case case_id
  
  puts "Sign it here: #{signing_case.response["Parties"].first["PartyUrl"]}"
else
  puts "Could not get signature url"
  result.errors.each do |error|
    puts error
  end
end
```
  
### Local development

Create a `.env` file in the root directory to run the integration tests against your Assently test environment.

```sh
ASSENTLY_API_KEY=your-api-key
ASSENTLY_API_KEY=your-api-secret
```


## Contributing

Contributions is more than welcome!

Just create a fork and submit a pull request.

Please adhere to the coding standards used in the project and add tests.

