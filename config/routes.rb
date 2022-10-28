Rails.application.routes.draw do
  root 'pages#index'
  require 'sidekiq/web'
  
  mount Sidekiq::Web => '/sidekiq'

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
end
