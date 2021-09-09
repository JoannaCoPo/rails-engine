# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#find'
      get 'items/find_all', to: 'items/search#find_all'

      get 'merchants/:id/items', to: 'merchants/items#index'

      resources :items, only: %i[index create]
      resources :merchants, only: %i[index show]

      namespace :revenue do
        get '/merchants', to: 'merchants#most_revenue' #naming per postman test
        get '/merchants/:id', to: 'merchants#total_revenue'
      end
    end
  end
end
