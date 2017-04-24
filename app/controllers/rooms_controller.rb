class RoomsController < ApplicationController
  include ChannelAuthentication

  before_action :ensure_current_user
  before_action :ensure_channel_user

  def show
    @room = Room.find(room_params[:id])
    @message = Message.new
  end

  private

  def room_params
    params.permit(:id)
  end
end
