# GmailApiJp

GmailApiJp helps you create Gmail drafts more easily by using Ruby.  
It lets you avoid implementing a complicated coding on handling Gmail API to do so.  
This Gem completely supports Japanese language.

## Preparation

You need to create an application and have client_secret.json to use Gmail API.  
see:
https://developers.google.com/gmail/api/quickstart/ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gmail_api_jp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gmail_api_jp

Put a yaml file named `gmail_draft.yml` to your application's root directory.
the yaml file should be like: 
```yaml
application_name: Your application name 
client_secrets_path: "/Path/to/your/client_secret.json"
```
## Usage

First, require gmail_api_jp.  
`require 'gmail_api_jp'`

Create a string for the draft like this:
```ruby
text =<<TEXT
To: foo@example.com
Cc: bar@example.com, baz@example.com
Subject: Hello, my friend

Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident,
sunt in culpa qui officia deserunt mollit anim id est laborum.
TEXT
```

Then, initialize a GmailApiJp::Draft instance with the string you just declared.
```ruby
draft = GmailApiJp::Draft.new(text)
draft.create_draft
```
Congratulations!   
You will see a new draft when you sign in your Gmail account.  

Subject and Body can handle Japanese characters.

NOTE: First time you initialize GmailApiJp::Draft, it requires authorization.  
Just follow the instruction.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kenta-s/gmail_api_jp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
