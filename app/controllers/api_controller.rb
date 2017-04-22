class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :ensure_json

  private

  def ensure_json
    return if request.format == :json
    head :not_acceptable
  end
end
