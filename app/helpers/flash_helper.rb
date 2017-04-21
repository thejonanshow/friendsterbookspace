module FlashHelper
  def flash_errors_for(broken)
    broken.errors.full_messages.each do |message|
      flash_message(error: message)
    end
  end

  def flash_message(message)
    message_type = message.keys.first
    flash[message_type] ||= []
    flash[message_type] << message.values.first
  end
end
