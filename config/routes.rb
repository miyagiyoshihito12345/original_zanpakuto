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
    collection do
      get :my_post_order
      get :my_draft_order
      get :my_reiatu_order
    end
  end

  resources :posts do
    collection do
      get :index_new_order, :index_edit_order, :index_reiatu_order,
        :search_shikai, :search_bankai, :search_username, :search_tag
    end
  end

  resources :reiatus, only: %i[create destroy]
  resources :ai_posts, only: %i[ new ]
end
