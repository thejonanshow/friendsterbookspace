class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_commit :broadcast, on: :create

  validates :content, presence: true, allow_blank: false

  def alexa_user
    @alexa ||= User.find_or_create_by(name: "Alexa")
  end

  def send_audio_to_browser
    return unless reply_url

    ActionCable.server.broadcast(
      user.channel,
      id: reply_url.split("/").last.split(".").first,
      url: reply_url,
      type: "audio"
    )
  end

  def broadcast
    if command?
      handle_command
    else
      ActionCable.server.broadcast(
        "messages",
        message: content,
        user_name: user.name
      )
    end
  end

  def command?
    content.match(/^(ask|say)/)
  end

  def handle_command
    return reply_no_alexa unless user.amazon_token?

    if content.match(/^ask /)
      alexa_says("#{user.name} asked: #{content.split(' ', 2).last}")
    elsif content.match(/^say /)
      alexa_says("#{user.name} asked me to say: #{content.split(' ', 2).last}")
    end

    AlexaQueryJob.perform_later(id)
  end

  def alexa_says(words)
    m = Message.create(
      user: alexa_user,
      room: room,
      content: words
    )
  end
end
