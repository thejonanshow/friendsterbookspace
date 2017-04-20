Rails.application.routes.draw do
  get 'rooms/show'

  root "welcome#index"
end
