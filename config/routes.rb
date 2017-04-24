Rails.application.routes.draw do
  get "callbacks/amazon"

  resources :sessions, only: [:create, :destroy]
  resources :rooms, only: [:show]
  resources :messages, only: [:create]
  resources :access_tokens, only: [:destroy]

  namespace :api do
    resources :messages, only: [:create], constraints: { format: :json }
  end

  get "/auth/:provider/callback", to: "sessions#create"
  get "/access_tokens/refresh", to: "access_tokens#refresh"
  get "/sessions/create_channel_user", to: "sessions#create_channel_user"

  root "welcome#index"
end
