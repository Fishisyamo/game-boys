Rails.application.routes.draw do
  root to: 'toppages#index'

  get  'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, only: [:show,]
end