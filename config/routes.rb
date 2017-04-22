Rails.application.routes.draw do
  resources :sessions, only: [:create, :destroy]
  resources :rooms, only: [:show]
  resources :messages, only: [:create]

  namespace :api do
    resources :messages, only: [:create], constraints: { format: :json }
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  root "welcome#index"
end
