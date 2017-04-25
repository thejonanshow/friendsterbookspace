class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_commit :broadcast, on: :create

  validates :content, presence: true, allow_blank: false

  def from_api?
    @api_source ||= false
  end

  def not_from_api?
    !from_api?
  end

  def from_api=(truthiness)
    @api_source = truthiness
  end

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
    if content.match(/^(ask|say)/) && user_is_not_alexa?
      handle_command
    else
      ActionCable.server.broadcast(
        "messages",
        message: content,
        user_name: user.name
      )
    end
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

  def reply_no_alexa
    alexa_says("Sorry, I have measured you and found you lacking. Did you add magic amazon powers?")
    destroy
  end

  def user_is_not_alexa?
    !user_is_alexa?
  end

  def user_is_alexa?
    user.name == "Alexa" && not_from_api?
  end
end
