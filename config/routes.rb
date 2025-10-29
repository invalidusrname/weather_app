Rails.application.routes.draw do
  get "version" => "version#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "up" => "rails/health#show", as: :rails_health_check

  get "weather/index"
  get "weather/forecast", to: "weather#forecast"
  post "weather/forecast", to: "weather#forecast"

  root "weather#index"
end
