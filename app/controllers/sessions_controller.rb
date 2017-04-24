class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
    redirect_to room_path(Room.default)
  end

  def destroy
    self.current_user = nil
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
