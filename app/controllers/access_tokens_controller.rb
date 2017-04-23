class AccessTokensController < ApplicationController
  def refresh
    current_user.access_tokens.where(provider: "amazon").first.refresh
    redirect_to room_path(Room.default)
  end
end
