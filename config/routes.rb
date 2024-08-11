Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      # resources :tokens, only: [:create]
      post 'login', to: 'tokens#create'
    end

  end
end
