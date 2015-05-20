Rails.application.routes.draw do

  root 'pages#home'

  # Authentication
  get 'login' => 'sessions#new'
  post 'sessions' => 'sessions#create'
  delete 'sessions' => 'sessions#destroy'

  # Tutorials
  resources :tutorials, only: [:new, :create, :index]
  get 'tutorial/:slug'        => 'tutorials#show', as: :tutorial
  get 'tutorials/tagged/:tag' => 'tutorials#index', as: :tutorials_tagged

  # Blog
  resources :blogs, only: [:new, :create, :index]
  get 'blog/:slug'        => 'blogs#show', as: :blog
  get 'blogs/tagged/:tag' => 'blogs#index', as: :blogs_tagged

  # Posts
  resources :posts, only: [:new, :create, :index, :show]
  get 'posts/:slug'       => 'posts#show', as: :posts_slugged
  get 'posts/tagged/:tag' => 'posts#index', as: :posts_tagged

  # Comments
  resources :comments, only: [:create]

  # Likes 
  resources :likes, only: [:create]

  # Image uploads
  resources :image_contents, only: [:create]

  # Markdown preview
  post '/preview'    => 'preview#convert'
end
