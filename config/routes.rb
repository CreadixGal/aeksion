Rails.application.routes.draw do

  require 'sidekiq/web'
  
  mount Sidekiq::Web => '/sidekiq'

  resources :customers do 
    collection do
      post :search
      delete :multiple_delete
    end
  end
  root 'pages#index'
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get '/test-coverage', :to => redirect('/coverage/index.html')
end
