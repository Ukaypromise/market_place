Rails.application.routes.draw do
  root to: proc { [200, {}, ['API is now running']] }

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      post 'login', to: 'tokens#create'
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :orders, only: [:index, :show, :create]
    end

  end
end
