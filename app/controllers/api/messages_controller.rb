class Api::MessagesController < ApiController
  before_action :invalid_api_key?, :set_user, :set_room

  def create
    return head :not_acceptable unless message_params

    message = Message.new(
      user: @user,
      room: @room || Room.default,
      content: message_params[:content]
    )

    if invalid_api_key?
      head :unauthorized
    elsif message.save
      head :created
    elsif message.errors
      head :unprocessable, params: { errors: message.errors.full_messages }
    else
      head :internal_server_error
    end
  end

  private

  def set_user
    return unless message_params
    return if invalid_api_key?

    @user ||= User.find_or_create_by(name: message_params.dig(:user, :name))
  end

  def set_room
    return unless message_params

    slug = message_params.dig(:room, :slug)
    return unless slug

    @room ||= Room.find_by(slug: slug)
  end

  def message_params
    params.require(:message).permit(:content, user: [:name], room: [:slug])
  rescue NoMethodError
  end

  def api_key_params
    params.permit(:api_key)
  end

  def invalid_api_key?
    !valid_api_key?
  end

  def valid_api_key?
    api_key_params[:api_key] == ENV["MESSAGES_API_KEY"]
  end
end
