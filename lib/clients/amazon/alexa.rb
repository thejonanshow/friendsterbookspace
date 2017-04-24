module Clients
  module Amazon
    class Alexa
      def initialize(token)
        @token = token
        @connection = connect
      end

      def alexa_skill_url
        "https://access-alexa-na.amazon.com"
      end

      def json_path
        File.join(Rails.root, "avs_metadata.json")
      end

      def audio_path
        File.join(Rails.root, "trigger_skill.wav")
      end

      def payload
        {
          :files[0] => Faraday::UploadIO.new(json_path, "application/json"),
          :files[1] => Faraday::UploadIO.new(audio_path, "audio/wav")
        }
      end

      def refresh_and_reset_connection
        @token.refresh
        @connection = connect
      end

      def post_audio
        refresh_and_reset_connection unless @token.valid_token?

        response = @connection.post do |request|
          request.url "/v1/avs/speechrecognizer/recognize"
          request.body = payload
        end

        File.open("response.mp3", "wb") { |file| file.write(response.body) }
      end

      def headers
        {
          "Content-Type" => "multipart/form-data",
          "Transfer-Encoding" => "chunked",
          "Authorization" => "Bearer #{@token.token}"
        }
      end

      def connect
        Faraday.new(url: alexa_skill_url) do |faraday|
          faraday.request :multipart
          faraday.response :logger, Logger.new(STDOUT)
          faraday.adapter Faraday.default_adapter
          faraday.headers = headers
        end
      end
    end
  end
end
