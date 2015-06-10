[![Build Status](https://travis-ci.org/Oktavilla/egree-ruby.svg?branch=master)](https://travis-ci.org/Oktavilla/egree-ruby)
[![Code Climate](https://codeclimate.com/github/Oktavilla/egree-ruby/badges/gpa.svg)](https://codeclimate.com/github/Oktavilla/egree-ruby)
[![Test Coverage](https://codeclimate.com/github/Oktavilla/egree-ruby/badges/coverage.svg)](https://codeclimate.com/github/Oktavilla/egree-ruby)
[![Gem Version](https://badge.fury.io/rb/egree.svg)](http://badge.fury.io/rb/egree)

# Egree

Ruby client for the [Assently API](https://app.assently.com/apiv1).

__You're on branch api/v2, if you want to use apiv1, checkout [master](https://github.com/kollegorna/egree-ruby/tree/master).__

Ruby client for the [Egree API V2](https://app.egree.com/api).

Currently the only supported api calls is `createcase`, `sendcase` and `getcase`.

### Note
If you miss `getviewcaseurlquery`, this is how you can get the view case url.

```
signing_case = egree.get_case case_id
signing_case.response["Parties"].first["PartyUrl"] # Each party gets their own url

```

## Usage

### Creating a case

```ruby
egree = Egree.client egree_api_key, egree_api_secret

case_id = SecureRandom.uuid

signature_case = Egree::Case.new "Agreement", ["electronicid"], case_id: case_id
signature_case.add_party Egree::Party.new_with_attributes({
  name: "First Last",
  email: "name@example.com",
  social_security_number: "1234567890"
})
signature_case.add_document Egree::Document.new "/some/path/file.pdf"

result = egree.create_case(signature_case, {
  # Egree sends a POST with the signed case as the JSON body when the signing process is finished.
  postback_url: "https://example.com/my-endpoint",
  continue: {
    # user ends up here after finishing the signing process
    url: "http://example.com/user-endpoint",
    auto: true
  },
  # User ends up here when cancelling, at the moment there is no cancel callback
  cancel_url: "http://example.com/user-canceled",
  # Procedure can be ”default” or ”form”, this changes some copy in the Egree interface.
  # defaults to ”default”
  procedure: "form"
})

if result.success?
  puts "#{signature_case.reference_id} was created."
else 
  puts "There was some issues with the case"
  result.errors.each do |error|
    puts error
  end
end
```

### Getting the signature url for a case

```ruby
egree = Egree.client username, password
result = egree.get_case_url "98d08cf5-d35d-403b-ac31-fa1ac85037a1"

if result.success?
  puts "The url is: #{result.response}"
  egree.send_case case_id
  
  signing_case = egree.get_case case_id
  
  puts "Sign here: #{signing_case.response["Parties"].first["PartyUrl"]}"
else
  puts "Could not get signature url"
  result.errors.each do |error|
    puts error
  end
end
```
  


## Contributing

Contributions is more than welcome!

Just create a fork and submit a pull request.

Please adhere to the coding standards used in the project and add tests.

### Local development

Create a .env file in the root directory to run the integration tests against your Egree environment.

```yaml
EGREE_API_KEY=your-api-key
EGREE_API_SECRET=your-api-secret
```

You can get them here: ```https://test.egree.com/a/account/api```


