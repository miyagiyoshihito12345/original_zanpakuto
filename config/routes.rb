Rails.application.routes.draw do
  root 'posts#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'search', to: 'posts#search'
  post 'ai_generate', to: 'ai_posts#ai_generate'
  get 'aaaaa', to: 'ai_posts#aaaaa'
  get 'new_ai', to: 'ai_posts#new_ai'
  get 'fight_select', to: 'posts#fight_select'
  get 'fight', to: 'posts#fight'
  get 'fight_detail', to: 'posts#fight_detail'
  get 'fight_close', to: 'posts#fight_close'

  resources :users, only: %i[new create]
  resource :profiles, only: %i[show edit update] do
    get :my_post_order, on: :collection
    get :my_draft_order, on: :collection
    get :my_reiatu_order, on: :collection
  end
  resources :posts do
    get :index_new_order, on: :collection
    get :index_edit_order, on: :collection
    get :index_reiatu_order, on: :collection
    get :search_shikai, on: :collection
    get :search_bankai, on: :collection
    get :search_username, on: :collection
    get :search_tag, on: :collection
  end
  resources :reiatus, only: %i[create destroy]
  resources :ai_posts, only: %i[ new ]
end
