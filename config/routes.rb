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
    post 'confirmed', on: :member
    post 'canceled', on: :member
  end

end
