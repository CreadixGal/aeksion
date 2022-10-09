Rails.application.routes.draw do
  # WEB
  root 'pages#index'
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  
  # API
  namespace :api do
    namespace :v1 do
      resources :customers
    end
  end

  # monitoring
  get '/test-coverage', :to => redirect('/coverage/index.html')
end
