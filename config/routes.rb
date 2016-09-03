require 'resque/server'

Rails.application.routes.draw do

  mount Resque::Server.new, :at => "/resque"

  devise_for :users, :controllers => {
    :omniauth_callbacks => 'omniauth'
  }

  authenticated :user do
    root to: redirect('/map') #to: 'drafts#map', :as => :authenticated_root
  end

  root to: 'pages#landing', as: :unauthenticated_root
  get 'video', to: 'pages#video'

  resources :jobs, only: [:index, :create]
  resources :setups
  resources :uploads, except: [:new, :show, :delete]
  get 'map', to: 'drafts#map', as: :map
  resources :drafts
  resources :activities, :only => [:index, :show] do
    post '/recut' => 'activities#recut', as: :recut
  end

  resource :slate, only: [:show] do
    get 'now', to: 'slates#now', as: :now
  end

  post 'sns' => 'sns#message', as: :sns
  get 'sns' => 'sns#message'

  resource :settings, only: [ :show ]

  namespace :api, :defaults => { :format => 'json' } do
    post '/dropbox_webhook' => 'dropbox_webhooks#webhook'
    get '/dropbox_webhook' => 'dropbox_webhooks#webhook'
  end

  get '/dropbox' => 'dropbox_browser#index', :as => :dropbox_browser
  resources :dropbox_events, :only => [:index, :create, :show]
end
