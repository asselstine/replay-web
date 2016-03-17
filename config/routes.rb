require 'resque/server'

Rails.application.routes.draw do

  mount Resque::Server.new, :at => "/resque"

  devise_for :users, :controllers => {
    :sessions => 'sessions',
    :omniauth_callbacks => 'omniauth'
  }

  authenticated :user do
    root :to => 'feeds#show', :as => :authenticated_root
  end

  root to: 'pages#landing', as: :unauthenticated_root

  resources :rides, :only => [:index, :show]
  resources :locations, :only => [:index]
  resource :feed
  resources :edits, :only => [] do
    member do
      post '/reprocess' => 'edits#reprocess', as: :reprocess
    end
  end

  resource :slate, only: [:show] do
    get 'now', to: 'slates#now', as: :now
  end

  post 'sns' => 'sns#message', as: :sns
  get 'sns' => 'sns#message'

  resources :recording_sessions
  resources :cameras
  resources :videos

  resources :photos do
    collection do
      get '/uploaded' => 'photos#uploaded', :as => :uploaded
    end
  end

  resource :settings, only: [ :show ]

  namespace :api, :defaults => { :format => 'json' } do
    post '/dropbox_webhook' => 'dropbox_webhooks#webhook'
    get '/dropbox_webhook' => 'dropbox_webhooks#webhook'
  end

  get '/dropbox' => 'dropbox_browser#index', :as => :dropbox_browser
  resources :dropbox_events, :only => [:index, :create, :show]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
