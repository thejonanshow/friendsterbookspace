class AlexaQueryJob < ApplicationJob
  rescue_from StandardError do |error|
    Rails.logger.error "[#{self.class.name}] failed: #{error.to_s}"
    Rails.logger.error error.backtrace.join("\n")
  end

  after_perform do |job|
    Message.find(job.arguments.first).send_audio_to_browser
  end

  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)

    action, text = message.content.split(" ", 2)

    alexa = AlexaQuery.new(message.user)

    case action.downcase
    when "ask"
      url = alexa.ask text
    when "say"
      url = alexa.say text
    end

    message.update_attributes(reply_url: url) if url
  end
end
