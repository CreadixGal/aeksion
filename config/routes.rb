# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  # SIDEKIQ
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # WEB
  root 'pages#index'

  resources :customers do
    collection do
      post :search
      delete :multiple_delete # TODO: move this to a concern
    end
  end

  resources :movements do
    collection do
      delete :multiple_delete # TODO: move this to a concern
    end
  end

  resources :rates do
    collection do
      delete :multiple_delete # TODO: move this to a concern
    end
  end
  
  resources :zones do
    collection do
      delete :multiple_delete # TODO: move this to a concern
    end
  end

  resources :products

  get 'dashboard',      to: 'pages#dashboard', as: :dashboard
  get 'configuration',  to: 'pages#configuration', as: :configuration
  get '/test-coverage', to: redirect('/coverage/index.html')

  # authentication
  devise_for :users,
    path: 'auth',
    controllers: { 
      sessions: 'user_sessions'
    },
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    }

  # API
  namespace :api do
    namespace :v1 do
      resources :customers, only: [:index, :show, :create, :destroy] do
        collection do
          patch :bulk_update
          post :create_bulk
        end
      end
      resources :zones, only: [:index, :show, :create, :destroy] do
        collection do
          patch :bulk_update
          post :create_bulk
        end
      end
      resources :rates, only: [:index, :show, :create, :destroy] do
        collection do
          patch :bulk_update
          post :create_bulk
        end
      end
      resources :products, only: [:index, :show, :create, :destroy] do
        collection do
          patch :bulk_update
          post :create_bulk
        end
      end
      resources :movements, only: [:index, :show, :create, :destroy] do
        collection do
          patch :bulk_update
          post :create_bulk
        end
      end
      resources :product_movements, only: [:index, :show, :create, :destroy] do
        collection do
          patch :bulk_update
          post :create_bulk
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength