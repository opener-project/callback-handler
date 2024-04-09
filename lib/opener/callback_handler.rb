require 'json'
require 'aws-sdk-sqs'
require 'httpclient'
require 'addressable/uri'

require_relative 'callback_handler/version'
require_relative 'callback_handler/strategies/amazon_sqs'
require_relative 'callback_handler/strategies/http'

module Opener
  class CallbackHandler
    ##
    # The available strategies. These are processed in order to make sure the
    # order is correct (e.g. AmazonSqs should take precedence over Http).
    #
    # @return [Array]
    #
    STRATEGIES = [
      Opener::CallbackHandler::Strategies::AmazonSqs,
      Opener::CallbackHandler::Strategies::Http,
    ]

    ##
    # @param [String] url
    # @param [Hash] params
    #
    def post(url, params = {})
      strategy = select_strategy(url)

      unless strategy
        raise ArgumentError, "No strategy for URL #{url.inspect}"
      end

      strategy.new.process(url, params)
    end

    ##
    # Returns the strategy class to use based on the input URL.
    #
    # @param [String] url
    # @return [Class]
    #
    def select_strategy(url)
      return STRATEGIES.find do |const|
        const.pass_validation?(url)
      end
    end
  end # CallbackHandler
end # Opener
