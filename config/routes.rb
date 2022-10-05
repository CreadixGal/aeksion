Rails.application.routes.draw do
  root 'pages#index'
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  
end
