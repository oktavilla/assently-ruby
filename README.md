[![Build Status](https://travis-ci.org/joeljunstrom/egree-ruby.svg?branch=master)](https://travis-ci.org/joeljunstrom/egree-ruby)
[![Code Climate](https://codeclimate.com/github/joeljunstrom/egree-ruby/badges/gpa.svg)](https://codeclimate.com/github/joeljunstrom/egree-ruby)
[![Test Coverage](https://codeclimate.com/github/joeljunstrom/egree-ruby/badges/coverage.svg)](https://codeclimate.com/github/joeljunstrom/egree-ruby)
[![Gem Version](https://badge.fury.io/rb/egree.svg)](http://badge.fury.io/rb/egree)

# Egree

Ruby client for the [Egree API](https://app.egree.com/apiv1).

Currently the only supported actions is the `createcasecommand` and `getviewcaseurlquery`.

## Usage

### Creating a case

```
  egree = Egree.client username, password

  signature_case = Egree::Case.new "Agreement", ["touch"]
  signature_case.add_party Egree::Party.new({
    name: "First Last",
    email: "name@example.com",
    social_security_number: "1234567890"
  })
  signature_case.add_document Egree::Document.new "/some/path/file.pdf"

  result = egree.create_case signature_case

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

```
  egree = Egree.client username, password
  result = egree.get_case_url "98d08cf5-d35d-403b-ac31-fa1ac85037a1"

  if result.success?
	puts "The url is: #{result.response}"
  else
	puts "Could not get signature url"
	result.errors.each do |error|
      puts error
	end
  end
```
  


## Contributing

1. Fork it ( http://github.com/joeljunstrom/egree/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Local development

Create a .env file in the root directory.

```
EGREE_USERNAME=your-username
EGREE_PASSWORD=your-password
```

This is used for the integration tests.
