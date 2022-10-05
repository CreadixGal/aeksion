Rails.application.routes.draw do
  root 'pages#index'
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get '/test-coverage', :to => redirect('/coverage/index.html')
end
