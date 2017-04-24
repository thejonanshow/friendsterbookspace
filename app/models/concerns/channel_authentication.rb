module ChannelAuthentication
  private

  def ensure_channel_user
    authenticate_channel_user(cookies.signed[:user_id]) || redirect_to("/sessions/create_channel_user")
  end

  def authenticate_channel_user(user_id)
    if authenticated_user = User.find_by(id: user_id)
      cookies.signed[:user_id] ||= user_id
      @current_channel_user = authenticated_user
    end
  end

  def unauthenticate_channel_user
    cookies.delete(:user_id)
    @current_channel_user = nil
  end
end
