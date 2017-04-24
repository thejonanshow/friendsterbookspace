class ApiController < ApplicationController
  protect_from_forgery with: :null_session, if: ->{request.format.json?}
end
