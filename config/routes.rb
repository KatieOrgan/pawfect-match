Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#landing'

  resources :pets, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :bookings, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :users, only: [:show] do
    member do
      patch :update_user_details
      patch :update_profile_picture
      delete :delete_profile_picture
    end
  end
end
