module Opener
  class CallbackHandler
    module Strategies
      ##
      # Strategy for submitting data to a regular HTTP URL. This strategy
      # submits data as JSON while making sure the correct Content-Type header
      # is set.
      #
      # @!attribute [r] http
      #  @return [HTTPClient]
      #
      class Http
        attr_reader :http

        ##
        # The headers to use when submitting data.
        #
        # @return [Hash]
        #
        HEADERS = {
          'Content-Type' => 'application/json'
        }

        ##
        # @param [String] url
        # @return [TrueClass|FalseClass]
        #
        def self.pass_validation?(url)
          return !!Regexp.new("^https?:\/\/.+").match(url)
        end

        def initialize
          @http = HTTPClient.new
        end

        ##
        # @param [String] url
        # @param [Hash] params
        #
        def process(url, params = {})
          if params.key?(:body)
            body_data = params[:body]
          else
            body_data = params
          end
          body = JSON.dump(body_data)

          http.post(url, body, HEADERS)
        end
      end # Http
    end # Strategies
  end # CallbackHandler
end # Opener
