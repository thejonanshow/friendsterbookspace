class MessagesController < ApplicationController
  def create
    content = 
    @message = Message.new(
      user: current_user,
      room_id: message_params[:message][:room_id],
      content: message_params[:message][:content]
    )

    unless @message.save
      flash_errors_for(@message)
    end

    redirect_to room_path(@message.room)
  end

  private

  def message_params
    params.permit(message: [:id, :room_id, :content])
  end
end
