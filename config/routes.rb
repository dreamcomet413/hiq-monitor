Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users
  resources :users

  resources :crashes
  resources :crash_groups

  get '/home/crash_data', to: 'home#crash_data'
  get '/home/crash_group_data', to: 'home#crash_group_data'
  get '/home/crash_group_clouding', to: 'home#crash_group_clouding'

  post '/webhook', to: 'crashes#webhook'
  get '/webhook', to: 'crashes#webhook'
end
