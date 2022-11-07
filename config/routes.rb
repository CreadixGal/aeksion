Rails.application.routes.draw do

  # SIDEKIQ
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # WEB
  root 'pages#index'

  resources :customers do 
    collection do
      post :search
      delete :multiple_delete
    end
  end

  resources :products

  get 'dashboard',      to: 'pages#dashboard', as: :dashboard
  get 'configuration',  to: 'pages#configuration', as: :configuration
  get '/test-coverage', to: redirect('/coverage/index.html')

  # API
  namespace :api do
    namespace :v1 do
      resources :customers
    end
  end
end
