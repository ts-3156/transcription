Rails.application.routes.draw do
  root 'requests#index'
  resources :requests, only: %i(index show create)

  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
  }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
