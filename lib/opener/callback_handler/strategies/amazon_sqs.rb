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
      #  @return [AWS::SQS]
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
          @sqs = AWS::SQS.new
        end

        ##
        # @param [String] uri The queue URI
        # @param [Hash] params The message to submit.
        #
        def process(uri, params = {})
          queue = queue_for_uri(uri)

          queue.send_message(JSON.dump(params))
        end

        ##
        # @param [String] uri
        # @return [AWS::SQS::Queue]
        #
        def queue_for_uri(uri)
          parsed = Addressable::URI.parse(uri)

          return queue_for_name(parsed.host)
        end

        ##
        # @param [String] name
        # @return [AWS::SQS::Queue]
        #
        def queue_for_name(name)
          return sqs.queues.named(name)
        end
      end # AmazonSqs
    end # Strategies
  end # CallbackHandler
end # Opener
