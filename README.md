# Egree

TODO: Write a gem description

[![Build Status](https://travis-ci.org/joeljunstrom/egree-ruby.svg?branch=master)](https://travis-ci.org/joeljunstrom/egree-ruby)

## Installation

Add this line to your application's Gemfile:

    gem 'egree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install egree

## Usage

### Creating a case

```
  egree = Egree.client ENV["EGREE_USERNAME"], ENV["EGREE_PASSWORD"]

  signature_case = Egree::Case.new "Agreement", ["touch"]
  signature_case.add_party Egree::Party.new({
    name: "First Last",
    email: "name@example.com",
    social_security_number: "8305010012"
  })
  signature_case.add_document Egree::Document.new "/some/path/file.pdf"

  result = egree.create_case signature_case
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/egree/fork )
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
