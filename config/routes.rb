Rails.application.routes.draw do
  root 'posts#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'search', to: 'posts#search'

  resources :users, only: %i[new create]
  resource :profiles, only: %i[show edit update]
  resources :posts do
    get :search_shikai, on: :collection
    get :search_bankai, on: :collection
    get :search_username, on: :collection
    get :search_tag, on: :collection
  end
end
