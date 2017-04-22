class Api::MessagesController < ApiController
  before_action :set_user, :set_room

  def create
    message = Message.new(
      user: @user,
      room: @room || Room.default,
      content: message_params[:content]
    )

    if message.save
      head :created
    elsif message.errors
      head :unprocessable, params: { errors: message.errors.full_messages }
    else
      head :internal_server_error
    end
  end

  private

  def set_user
    @user ||= User.find_or_create_by(name: message_params.dig(:user, :name))
  end

  def set_room
    slug = message_params.dig(:room, :slug)
    return unless slug

    @room ||= Room.find_by(slug: slug)
  end

  def message_params
    params.require(:message).permit(:content, user: [:name], room: [:slug])
  end
end
