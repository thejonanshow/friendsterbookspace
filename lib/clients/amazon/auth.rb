module Clients
  module Amazon
    class Auth
      def self.fetch_token(code)
        post_tokens_endpoint(new_token_params(code))
      end

      def self.post_tokens_endpoint(params)
        response = connection.post do |request|
          request.url "/auth/o2/token"
          request.body = params
        end

        JSON.parse(response.body)
      end

      def self.web_url
        "https://www.amazon.com"
      end

      def self.api_url
        "https://api.amazon.com"
      end

      def self.redirect_uri
        "http://localhost:5000/callbacks/amazon"
      end

      def self.params
        {
          response_type: "code",
          redirect_uri: redirect_uri,
          client_id: ENV["AMAZON_CLIENT_ID"],
          scope: "alexa:all"
        }
      end

      def self.scope_data
        id = ENV["AMAZON_DEVICE_TYPE_ID"]
        sn = ENV["AMAZON_DEVICE_SERIAL_NUMBER"]
        "&scope_data=%7B%22alexa%3Aall%22%3A%7B%22productID%22%3A%22#{id}%22%2C%22productInstanceAttributes%22%3A%7B%22deviceSerialNumber%22%3A%22#{sn}%22%7D%7D%7D"
      end

      def self.auth_url
        "#{web_url}/ap/oa?" + params.to_query + scope_data
      end

      def self.connection(url = nil)
        Faraday.new(url: url || api_url) do |faraday|
          faraday.request :url_encoded
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
      end

      def self.new_token_params(code)
        token_params.merge({
          code: code,
          redirect_uri: redirect_uri,
          grant_type: "authorization_code"
        })
      end

      def self.token_params
        {
          client_id: ENV["AMAZON_CLIENT_ID"],
          client_secret: ENV["AMAZON_CLIENT_SECRET"]
        }
      end

      def self.refresh_token_params(token)
        token_params.merge({
          refresh_token: token,
          grant_type: "refresh_token"
        })
      end

      def self.refresh_token(token)
        post_tokens_endpoint(refresh_token_params(token))
      end
    end
  end
end
