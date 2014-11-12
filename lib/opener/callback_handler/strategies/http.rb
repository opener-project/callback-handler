module Opener
  class CallbackHandler
    module Strategies
      class Http

        def self.pass_validation?(url)
          !!Regexp.new("^https?:\/\/.*").match(url)
        end

        def process(url, params = {})
          body_params = params.keys.include?(:body) ? params : {:body => params}
          http_client.post_async(url, body_params)
        end

        def http_client
          client = ::HTTPClient.new
          client.connect_timeout = 120

          return client
        end
      end # Http
    end # Strategies
  end # CallbackHandler
end # Opener
