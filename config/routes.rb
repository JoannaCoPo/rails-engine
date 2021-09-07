# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/:id/items', to: 'merchants/items#index'
      get 'merchants/find', to: 'merchants/search#find'
      
      resources :items, only: %i[index create]
      resources :merchants, only: %i[index show]
      # resources :items, only: [:index]
      # get 'merchants/:id/items', to: 'merchants/items#index'
      # get 'merchants/find', to: 'merchants/search#find'

    end
  end
end
