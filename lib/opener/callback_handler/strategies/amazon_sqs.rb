require 'json'

module Opener
  class CallbackHandler
    module Strategies
      class AmazonSqs        
        def pass_validation?(url)
          !!Regexp.new("^https:\/\/sqs.(.*)amazonaws.com\/.*").match(url)
        end
        
        def process(url, params = {})
          send_message(url, params)
        end

        def send_message(url, params)
          sqs = ::Aws::SQS::Client.new
          params_json = params.is_a?(String) ? params : params.to_json
          message_body = params.keys.include?(:message_body) ? params : {:message_body => params_json}
          
          sqs.send_message(message_body.merge(:queue_url=>url))
        end
      end
    end
  end
end
