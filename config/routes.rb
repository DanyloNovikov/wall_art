# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admins

  root 'collections#index'
  resources :collections, only: %i[index show]
  resources :invoices, only: %i[create]

  authenticate :admin do
    namespace :administrator do
      mount Rswag::Ui::Engine => '/api-docs'
      mount Rswag::Api::Engine => '/api-docs'
      mount Sidekiq::Web => '/sidekiq'

      root to: 'dashboard#index'
      resources :invoices, only: %i[index show new create destroy]
      resources :plates
      resources :collections
    end
  end

  namespace :api do
    namespace :v1 do
      resources :auth, only: %i[create]
      resources :collections
      resources :invoices
      resources :plates
    end
  end
end
