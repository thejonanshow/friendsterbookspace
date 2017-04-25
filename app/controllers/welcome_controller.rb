class WelcomeController < ApplicationController
  skip_before_action :http_basic_auth

  def index
  end
end
