class AlexaQuery
  def initialize(user)
    @s3 = Clients::Amazon::S3.new
    @alexa = Clients::Amazon::Alexa.new(user.amazon_token)
    @polly = Clients::Amazon::Polly.new
  end

  def ask(text)
    wav = @polly.speak text
    mp3 = @alexa.send_audio(wav)
    mp3_filename = mp3.path.split("/").last
    @s3.upload_file(mp3_filename, mp3)
    @s3.url_for(mp3_filename)
  ensure
    File.delete(mp3.path)
  end

  def say(text)
    wav = @polly.speak "Simon says #{text}"
    mp3 = @alexa.send_audio(wav)
    mp3_filename = mp3.path.split("/").last
    @s3.upload_file(mp3_filename, mp3)
    @s3.url_for(mp3_filename)
  ensure
    File.delete(mp3.path)
  end
end
