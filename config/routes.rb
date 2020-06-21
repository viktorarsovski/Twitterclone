Rails.application.routes.draw do
  get 'tweets/index', to: 'tweets#index'
  get "/articles/:id", to: "articles#show"

  root to: 'tweets#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
