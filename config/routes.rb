Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'sessions' => 'sessions#create'
  delete 'sessions' => 'sessions#destroy'

  resources :doc_categories, only: %i(index create destroy) do
    collection do
      put :update
      patch :update
    end
  end

  resources :posts, except: [:show] do
    resources :likes, only: [:create] do
      collection do
        delete :destroy
      end
    end
    resources :comments, only: [:create]

    member do
      post :publish
      post :unpublish
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
      post :publish
      post :unpublish
    end
  end

  get 'tutorials/:slug', to: 'tutorials#show', as: :tutorials_slugged
  get 'tutorials/tagged/:tag', to: 'tutorials#index', as: :tutorials_tagged

  resources :docs, except: [:show] do
    resources :likes, only: [:create] do
      collection do
        delete :destroy
      end
    end

    member do
      post :publish
      post :unpublish
    end
  end

  get 'docs/:slug', to: 'docs#show', as: :docs_slugged
  get 'docs/tagged/:tag', to: 'docs#index', as: :docs_tagged

  resources :image_contents, only: [:create]

  post '/preview' => 'preview#convert'

  resources :drafts, only: [:index] do
    collection do
      get :posts
      get :tutorials
      get :docs
    end
  end

  resources :search, only: [] do
    collection do
      get :posts
      get :tutorials
    end
  end

  root 'home#index'
end
