Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'sessions' => 'sessions#create'
  delete 'sessions' => 'sessions#destroy'

  resources :posts, except: [:show] do
    resources :likes, only: [:create] do
      collection do
        delete :destroy
      end
    end
    resources :comments, only: [:create]

    member do
      put :publish
      put :unpublish
    end
  end
  get 'posts/:slug', to: 'posts#show', as: :posts_slugged
  get 'posts/tagged/:tag', to: 'posts#index', as: :posts_tagged

  resources :tutorials, except: [:show] do
    resources :likes, only: [:create] do
      collection do
        delete :destroy
      end
    end
    resources :comments, only: [:create]

    member do
      put :publish
      put :unpublish
    end
  end
  get 'tutorials/:slug', to: 'tutorials#show', as: :tutorials_slugged
  get 'tutorials/tagged/:tag', to: 'tutorials#index', as: :tutorials_tagged

  resources :image_contents, only: [:create]

  post '/preview'    => 'preview#convert'

  resources :drafts, only: [:index] do
    collection do
      get :posts
      get :tutorials
    end
  end

  root 'home#index'
end
