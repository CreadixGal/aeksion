Rails.application.routes.draw do
  resources :customers do 
    collection do
      post :search
    end
  end
  root 'pages#index'
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get '/test-coverage', :to => redirect('/coverage/index.html')
end
