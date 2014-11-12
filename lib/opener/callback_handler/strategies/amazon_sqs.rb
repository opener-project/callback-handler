module Opener
  class CallbackHandler
    module Strategies
      ##
      # Strategy for submitting data to an Amazon SQS queue.
      #
      class AmazonSqs
        ##
        # @param [String] url
        # @return [TrueClass|FalseClass]
        #
        def self.pass_validation?(url)
          return !!Regexp.new("^https:\/\/sqs.(.*)amazonaws.com\/.*").match(url)
        end

        ##
        # @param [String] url
        # @param [Hash] params
        #
        def process(url, params = {})
          send_message(url, params)
        end

        ##
        # @param [String] url
        # @param [Hash] params
        #
        def send_message(url, params)
          sqs = ::Aws::SQS::Client.new
          params_json = params.is_a?(String) ? params : params.to_json
          message_body = params.keys.include?(:message_body) ? params : {:message_body => params_json}

          sqs.send_message(message_body.merge(:queue_url=>url))
        end
      end # AmazonSqs
    end # Strategies
  end # CallbackHandler
end # Opener
