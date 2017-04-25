class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_save :broadcast

  validates :content, presence: true, allow_blank: false

  def broadcast
    return reply_no_alexa unless user.amazon_token?

    if content.match(/^ask /)
      ask_broadcast
    elsif content.match(/^say /)
      say_broadcast
    else
      ActionCable.server.broadcast(
        "messages",
        message: content,
        user_name: user.name
      )
    end
  end

  def ask_broadcast
    alexa_says("One moment please...")
    text = content.split(/^ask /).last
    alexa = AlexaQuery.new(user)

    url = alexa.ask text

    UsersChannel.broadcast_to(
      user,
      id: url.split("/").last.split(".").first,
      url: url,
      type: "audio"
    )
    alexa_says("My reply will play automatically, please make sure you have your volume turned up.")
  end

  def say_broadcast
    alexa_says("One moment please...")
    text = content.split(/^say /).last
    alexa = AlexaQuery.new(user)

    url = alexa.say text

    UsersChannel.broadcast_to(
      user,
      id: url.split("/").last.split(".").first,
      url: url,
      type: "audio"
    )

    alexa_says("My reply will play automatically, make sure you have your volume turned up.")
  end

  def alexa_says(words)
    ActionCable.server.broadcast(
      "messages",
      message: words,
      user_name: "Alexa"
    )
  end

  def reply_no_alexa
    alexa_says("Sorry, I have measured you and found you lacking. Did you add magic amazon powers?")
    destroy
  end
end
