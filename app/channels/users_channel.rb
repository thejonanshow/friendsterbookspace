class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_from current_channel_user.channel
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
