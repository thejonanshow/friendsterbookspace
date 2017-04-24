class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_save :broadcast

  validates :content, presence: true, allow_blank: false

  def broadcast
    ActionCable.server.broadcast(
      "messages",
      message: content,
      user_name: user.name
    )

    UsersChannel.broadcast_to(user, content)
  end
end
