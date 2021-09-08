# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#find'
      get 'merchants/:id/items', to: 'merchants/items#index'

      resources :items, only: %i[index create]
      resources :merchants, only: %i[index show]
    end
  end
end
