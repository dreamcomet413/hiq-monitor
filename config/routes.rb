Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users
  resources :users

  resources :crashes
  resources :crash_groups

  get '/home/carsh_data', to: 'home#crash_data'

  post '/webhook', to: 'crashes#webhook'
  get '/webhook', to: 'crashes#webhook'
end
