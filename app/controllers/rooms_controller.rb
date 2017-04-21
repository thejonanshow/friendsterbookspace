class RoomsController < ApplicationController
  def show
    @room = Room.find(room_params[:id])
    @message = Message.new
  end

  private

  def room_params
    params.permit(:id)
  end
end
