Rails.application.routes.draw do
  devise_for :buffet_owner_users
  root to: 'home#index'
end
