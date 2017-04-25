require "securerandom"

module Clients
  module Amazon
    class Polly
      attr_reader :client

      def initialize
        @client = Aws::Polly::Client.new(
          access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
        )
      end

      def speak(text, output_filename = nil)
        response = client.synthesize_speech(
          text: text,
          voice_id: "Joanna",
          output_format: "mp3"
        )

        tmp_filename ||= SecureRandom.uuid
        tmp_path = File.join(Rails.root, "tmp")

        mp3 = Tempfile.new([tmp_filename, "mp3"], tmp_path)
        mp3.write response.audio_stream.read
        mp3.close

        wav_path = File.join(Rails.root, "tmp", "#{tmp_filename}.wav")
        convert_mp3_to_wav(mp3.path, wav_path)

        wav = File.open(wav_path)
        wav
      ensure
        mp3.unlink
      end

      def convert_mp3_to_wav(mp3_name, wav_name)
        `ffmpeg -i #{mp3_name} -acodec pcm_s16le -ac 1 -ar 16000 #{wav_name}`
      end
    end
  end
end
