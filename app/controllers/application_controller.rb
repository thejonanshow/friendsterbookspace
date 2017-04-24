class ApplicationController < ActionController::Base
  include FlashHelper

  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_user=
  helper_method :admin_user?

  def current_user
    @user ||= User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def current_user=(user)
    if user
      @user = user
      session[:user_id] = user.id
    else
      session[:user_id] = @user = nil
    end
  end

  def admin_user?
    current_user && current_user.admin?
  end
end
