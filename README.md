[![Build Status](https://travis-ci.org/Oktavilla/egree-ruby.svg?branch=master)](https://travis-ci.org/Oktavilla/egree-ruby)
[![Code Climate](https://codeclimate.com/github/Oktavilla/egree-ruby/badges/gpa.svg)](https://codeclimate.com/github/Oktavilla/egree-ruby)
[![Test Coverage](https://codeclimate.com/github/Oktavilla/egree-ruby/badges/coverage.svg)](https://codeclimate.com/github/Oktavilla/egree-ruby)
[![Gem Version](https://badge.fury.io/rb/egree.svg)](http://badge.fury.io/rb/egree)

# Assently API Client

Ruby client for the [Assently API](https://assently.com/). Check out [the official API documentation here](https://app.assently.com/api/).

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

### Note
If you miss `getviewcaseurlquery`, this is how you can get the view case url.

```
signing_case = assently.get_case case_id
signing_case.response["Parties"].first["PartyUrl"] # Each party gets their own url

```

## Usage

### Creating a case

```ruby
assently = Assently.client assently_api_key, assently_api_secret

case_id = SecureRandom.uuid

signature_case = Assently::Case.new "Agreement", ["electronicid"], case_id: case_id
signature_case.add_party Assently::Party.new_with_attributes({
  name: "First Last",
  email: "name@example.com",
  social_security_number: "1234567890"
})
signature_case.add_document Assently::Document.new "/some/path/file.pdf"

result = assently.create_case(signature_case, {
  # Assently sends a POST with the signed case as the JSON body when the signing process is finished.
  postback_url: "https://example.com/my-endpoint",
  continue: {
    # user ends up here after finishing the signing process
    url: "http://example.com/user-endpoint",
    auto: true
  },
  # User ends up here when cancelling, at the moment there is no cancel callback
  cancel_url: "http://example.com/user-canceled",
  # Procedure can be ”default” or ”form”, this changes some copy in the Assently interface.
  # defaults to ”default”
  procedure: "form"
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

### Getting the signature url for a case

```ruby
assently = Assently.client API_KEY, API_SECRET
result = assently.get_case case_id

if result.success?
  puts "The url is: #{result.response}"
  assently.send_case case_id
  
  signing_case = assently.get_case case_id
  
  puts "Sign here: #{signing_case.response["Parties"].first["PartyUrl"]}"
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

