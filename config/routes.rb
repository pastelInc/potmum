Rails.application.routes.draw do
  mount PotmumAPI => '/api'
  mount GrapeSwaggerRails::Engine => '/api/swagger'

  root 'lobbies#root'
  get '/newest' => 'lobbies#newest', as: :newest_articles
  get '/popular' => 'lobbies#popular', as: :popular_articles
  get '/comments' => 'lobbies#comments', as: :newest_comments
  get '/search' => 'lobbies#search', as: :search
  get '/redirect' => 'lobbies#redirector', as: :redirector
  get '/browserconfig' => 'lobbies#browserconfig'

  scope '/@:name' do
    get '/' => 'users#show', as: :user
    get '/stocks' => 'users#stock_articles', as: :stocks_user
    get '/comments' => 'users#comments', as: :comments_user
    get '/drafts' => 'users#drafts', as: :drafts_user
    resources :articles, path: 'items' do
      collection do
        post 'preview'
      end
      resources :revisions, only: [:index, :show] do
        member do
          get 'preview'
        end
      end
      resources :comments, only: [:create]
      resource :stock, only: [:show, :update]
    end
  end
  get '/users/:name' => redirect('@%{name}')

  resources :comments, only: [:destroy] do
    collection do
      post 'preview'
    end
  end

  resources :tags, only: [:index, :show, :edit, :update], id: %r{.+?}, format: /json|html/ do
    member do
      get 'popular'
    end
  end

  resources :attachment_files, only: [:create]

  resource :users, only: [:update], path: 'setting', as: :setting do
    get '/' => 'users#edit'
  end

  namespace :users, path: 'setting' do
    resources :access_tokens, only: [:index, :create, :update, :destroy], path: 'tokens'
  end

  get '/register' => 'users#new', as: :register
  post '/register' => 'users#create'
  resource :session, only: [:destroy]

  get '/auth/:provider/callback' => 'sessions#callback'
  post '/auth/:provider/callback' => 'sessions#callback'
  get '/auth/failure' => 'sessions#failure', as: :auth_failure

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
