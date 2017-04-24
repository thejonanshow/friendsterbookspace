module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_channel_user

    def current_channel_user
      @current_channel_user ||= find_current_channel_user
    end

    private

    def find_current_channel_user
      User.find(cookies.signed[:user_id])
    end
  end
end
