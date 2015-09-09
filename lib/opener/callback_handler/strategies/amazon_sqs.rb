module Opener
  class CallbackHandler
    module Strategies
      ##
      # Strategy for submitting data to an Amazon SQS queue. This strategy
      # expects URIs in the following format:
      #
      #     sqs://<name>
      #
      # Here `<name>` is the name of the queue to use.
      #
      # @!attribute [r] sqs
      #  @return [Aws::SQS::Client]
      #
      class AmazonSqs
        attr_reader :sqs

        ##
        # @param [String] url
        # @return [TrueClass|FalseClass]
        #
        def self.pass_validation?(url)
          return !!(url =~ /^sqs:\/\/.+/)
        end

        def initialize
          @sqs = Aws::SQS::Client.new
        end

        # @param [String] uri The queue URI
        # @param [Hash] params The message to submit.
        def process(uri, params = {})
          queue_url = queue_url_for_uri(uri)

          sqs.send_message(
            :queue_url    => queue_url,
            :message_body => JSON.dump(params)
          )
        end

        # @param [String] uri
        # @return [String]
        def queue_url_for_uri(uri)
          parsed = Addressable::URI.parse(uri)

          return queue_url_for_name(parsed.host)
        end

        # @param [String] name
        # @return [String]
        def queue_url_for_name(name)
          sqs.get_queue_url(:queue_name => name).queue_url
        end
      end # AmazonSqs
    end # Strategies
  end # CallbackHandler
end # Opener
