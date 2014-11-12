module Opener
  class CallbackHandler
    module Strategies
      ##
      # Strategy for submitting data to a regular HTTP URL.
      #
      class Http
        ##
        # @param [String] url
        # @return [TrueClass|FalseClass]
        #
        def self.pass_validation?(url)
          !!Regexp.new("^https?:\/\/.*").match(url)
        end

        ##
        # @param [String] url
        # @param [Hash] params
        #
        def process(url, params = {})
          body_params = params.keys.include?(:body) ? params : {:body => params}

          http_client.post_async(url, body_params)
        end

        ##
        # @return [HTTPClient]
        #
        def http_client
          client = ::HTTPClient.new
          client.connect_timeout = 120

          return client
        end
      end # Http
    end # Strategies
  end # CallbackHandler
end # Opener
