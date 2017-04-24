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

      def payload(file)
        {
          :files[0] => Faraday::UploadIO.new(json_path, "application/json"),
          :files[1] => file
        }
      end

      def refresh_and_reset_connection
        @token.refresh
        @connection = connect
      end

      def send_audio(file)
        refresh_and_reset_connection unless @token.valid_token?
        payload_file = Faraday::UploadIO.new(file, "audio/wav", file.path)

        response = @connection.post do |request|
          request.url "/v1/avs/speechrecognizer/recognize"
          request.body = payload(payload_file)
        end

        tmp_filename = file.path.split("/").last.split(".").first
        tmp_path = File.join(Rails.root, "tmp", )
        mp3 = Tempfile.new([tmp_filename, ".mp3"], tmp_path, encoding: "ASCII-8BIT")

        mp3.write response.body
        mp3.close
        mp3
      ensure
        File.delete(file.path)
      end

      def send_trigger
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
