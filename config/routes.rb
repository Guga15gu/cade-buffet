Rails.application.routes.draw do
  devise_for :clients
  devise_for :buffet_owner_users
  root to: 'home#index'

  resources :buffets, only: [:new, :create, :show, :edit, :update] do
    get 'search', on: :collection
  end
  resources :buffet_types, only: [:new, :create, :show, :edit, :update]
  resources :buffet_type_prices, only: [:new, :create, :show, :edit, :update]

  resources :orders, only: [:new, :create, :show] do
    get 'client_index', on: :collection
    get 'buffet_owner_user_index', on: :collection
    post 'approved_by_buffet_owner', on: :member
    post 'confirmed_by_client', on: :member
    post 'canceled', on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :buffets, only: [:show, :index]
    end
  end
end
