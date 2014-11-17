require File.expand_path('../lib/opener/callback_handler/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'opener-callback-handler'
  spec.version       = Opener::CallbackHandler::VERSION
  spec.authors       = ['development@olery.com']
  spec.summary       = 'Tool for handling different callback URLs based on their protocol.'
  spec.description   = spec.summary

  spec.license = 'Apache 2.0'

  spec.files = Dir.glob([
    'lib/**/*',
    '*.gemspec',
    'README.md',
    'LICENSE.txt'
  ]).select { |file| File.file?(file) }

  spec.add_dependency 'aws-sdk', '~> 1.0'
  spec.add_dependency 'httpclient'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
