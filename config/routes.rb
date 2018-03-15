Rails.application.routes.draw do
  # toppages
  root to: 'toppages#index'

  # sessions
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # users
  get   'signup', to: 'users#new'
  post  'signup', to: 'users#create'
  patch '/users/:id/edit', to: 'users#update'
  resources :users, only: [:show, :edit, :update]

  # items
  resources :items, only: [:show, :new]
  # ownerships
  resources :ownerships, only: [:create, :destroy]
end