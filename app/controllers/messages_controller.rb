class MessagesController < ApplicationController
  def create
    @message = Message.new(
      user: current_user,
      room_id: message_params[:message][:room_id],
      content: message_params[:message][:content]
    )

    if @message.save
      ActionCable.server.broadcast(
        "messages",
        message: @message.content,
        user_name: @message.user.name
      )
    end

    head :created
  end

  private

  def message_params
    params.permit(message: [:id, :room_id, :content])
  end
end
