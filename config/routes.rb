# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :users, only: %i[create update] do
    collection do
      post 'login'
      delete 'logout'
    end
  end

  resources :comments do
    get 'page/:page', action: :index, on: :collection
  end

  resources :publications do
    get 'page/:page', action: :index, on: :collection
  end
end
