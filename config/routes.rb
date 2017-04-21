Rails.application.routes.draw do
  resources :sessions, only: [:create, :destroy]
  resources :rooms, only: [:show]

  get '/auth/:provider/callback', to: 'sessions#create'
  root "welcome#index"
end
