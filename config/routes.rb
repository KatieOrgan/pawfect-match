Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :pets, only: [:index, :show, :new, :create, :edit, :destroy, :update]
  resources :bookings, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :users, only: [:show, :edit, :update] do
    member do
      patch :update_user_details
      patch :update_profile_picture
    end
  end
  root to: 'pages#landing'
end
