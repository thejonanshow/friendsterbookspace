class WelcomeController < ApplicationController
  def index
    redirect_to room_path(Room.default) if current_user
  end
end
