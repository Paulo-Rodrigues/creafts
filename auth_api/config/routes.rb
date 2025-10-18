Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create ]
      post "login", to: "auth#login"
      get "me", to: "users#show"
      put "me", to: "users#update"
      put "change_password", to: "users#change_password"
    end
  end
end
