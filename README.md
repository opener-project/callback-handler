# Opener::CallbackHandler

Gem that handles the different callback URLs based on the protocol of each URL.

(HTTP, HTTPS, SQS, S3, FTP etc..) For now HTTP/HTTPS and Amazon SQS are
supported.

## Installation

Add this line to your application's Gemfile:

    gem 'opener-callback-handler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opener-callback-handler

## Usage

For SQS, `AWS_REGION` `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
environment variables should be set on startup of the webservice or daemon.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
