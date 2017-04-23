module Clients
  class Amazon
    def self.fetch_token(code)
      response = connection.post do |request|
        request.url "/auth/o2/token"
        request.body = token_params(code)
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

    def self.token_params(code)
      {
        grant_type: "authorization_code",
        code: code,
        client_id: ENV["AMAZON_CLIENT_ID"],
        client_secret: ENV["AMAZON_CLIENT_SECRET"],
        redirect_uri: redirect_uri
      }
    end

    def self.refresh_token(token)
    end
  end
end
