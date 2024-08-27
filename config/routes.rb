Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      post 'login', to: 'tokens#create'
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :orders, only: [:index, :show]
    end

  end
end
