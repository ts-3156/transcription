Rails.application.routes.draw do
  root 'requests#index'
  resources :requests, only: %i(index show create)

  # https://github.com/heartcombo/devise/wiki/How-To:-Disable-user-from-destroying-their-account
  devise_for :users, skip: [:registrations, :sessions]
  devise_scope :user do
    resource :registration,
             only: [:new, :create],
             path: 'users',
             path_names: {new: 'sign_up'},
             controller: 'users/registrations',
             as: :user_registration
    resource :session,
             only: [:new],
             path: 'users',
             path_names: {new: 'sign_in'},
             controller: 'devise/sessions',
             as: :user_session

    post 'users/sign_in' => 'users/sessions#create', as: 'user_session'
    match 'users/sign_out' => 'devise/sessions#destroy', as: 'destroy_user_session', via: [:get, :delete]
  end

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.id == 1 } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
