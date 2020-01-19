require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  namespace :admin do
    authenticate :user, lambda { |u| u.admin } do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  ActiveAdmin.routes(self)
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :users
      resources :products, only: %i[index]

      # match "signup" => "registrations#client_signup", :via => :post
      post '/sign_up' => 'registrations#client_signup'
    end
  end
end
