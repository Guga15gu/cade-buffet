Rails.application.routes.draw do
  devise_for :buffet_owner_users
  root to: 'home#index'

  resources :buffets, only: [:new, :create, :show, :edit, :update]
  resources :buffet_types, only: [:new, :create, :show, :edit, :update]
end
