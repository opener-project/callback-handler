require 'active_support/inflector'
require "opener/callback_handler/version"
require 'aws-sdk-core'
require 'httpclient'

##
# First strategy that passes the validation is served. So make sure that
# if there are overlapping strategies, to put the one that needs to
# be handled, first. For example amazon_sqs URLs are also http URLs, but need
# to be handled by the amazon_sqs strategy. so http should go after the
# amazon_sqs strategy.
STRATEGIES = ["amazon_sqs", "http"]
STRATEGIES.each do |strategy|
  require "opener/callback_handler/strategies/#{strategy}"
end

module Opener
  class CallbackHandler
    attr_accessor :url
    
    def post(url, params = {})
      strategy = select_strategy(url)
      strategy.process(url, params)
    end
    
    
    def select_strategy(url)
      STRATEGIES.map do |strategy|
        "Opener::CallbackHandler::Strategies::#{strategy.camelize}".constantize.new
      end.select do |strategy_class|
        strategy_class.pass_validation?(url)        
      end.compact.first
    end
  end
end
