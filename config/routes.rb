Rails.application.routes.draw do

  root 'posts#index'

  # Authentication
  get 'login' => 'sessions#new'
  post 'sessions' => 'sessions#create'
  delete 'sessions' => 'sessions#destroy'

  # Posts
  resources :posts, only: [:new, :create, :index] do
    resources :likes, only: [:create]
    resources :comments, only: [:create]
  end
  get 'posts/:slug', to: 'posts#show', as: :posts_slugged
  get 'posts/:type/tagged/:tag', to: 'posts#index', as: :posts_tagged



  # Image uploads
  resources :image_contents, only: [:create]

  # Markdown preview
  post '/preview'    => 'preview#convert'
end
