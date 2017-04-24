class MessagesController < ApplicationController
  def create
    @message = Message.create(
      user: current_user,
      room_id: message_params[:message][:room_id],
      content: message_params[:message][:content]
    )

    head :created
  end

  private

  def message_params
    params.permit(message: [:id, :room_id, :content])
  end
end
