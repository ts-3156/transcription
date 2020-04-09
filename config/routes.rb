Rails.application.routes.draw do
  root 'requests#index'
  resources :requests, only: %i(index show create)
end
