class SessionsController < ApplicationController
  include ChannelAuthentication

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user

    if @user.amazon_token?
      destination = room_path(Room.default)
    else
      destination = Clients::Amazon::Auth.auth_url
    end

    redirect_to destination
  end

  def create_channel_user
    authenticate_channel_user(current_user.id)
    redirect_to room_path(Room.default)
  end

  def destroy
    self.current_user = nil
    unauthenticate_channel_user
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
