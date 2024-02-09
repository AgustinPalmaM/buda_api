# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

  namespace :api do
    namespace :v1 do
      get 'spreads/spread', to: 'spreads#spread'
      get 'spreads/all', to: 'spreads#spread_all'
      get 'spreads/alert', to: 'spreads#spread_alert'
      get 'spreads/polling', to: 'spreads#polling'
    end
  end
  # root "posts#index"
end
