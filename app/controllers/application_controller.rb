class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_user=

  def current_user
    @user ||= User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def current_user=(user)
    @user = user
    session[:user_id] = user.id
  end
end
