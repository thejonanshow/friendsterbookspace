class ApplicationController < ActionController::Base
  include FlashHelper

  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_user=
  helper_method :admin_user?

  before_action :http_basic_auth

  def http_basic_auth
    if ENV["HTTP_AUTH"] =~ %r{(.+)\:(.+)}
      unless authenticate_with_http_basic { |user, password|  user == $1 && password == $2 }
        request_http_basic_authentication
      end
    end
  end

  def ensure_current_user
    redirect_to "/auth/google_oauth2" unless current_user
  end

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
