Rails.application.routes.draw do
  get 'home/index'

  scope path: '/api' do
    api_version(module: "Api::V1", path: { value: "v1" }, defaults: { format: 'json' }) do
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  mount Sidekiq::Web => '/queue'

  resources :campaigns, only: [:index, :show], param: :slug

  root to: 'campaigns#index'

  namespace :admin do
    resources :locations do
      resources :devices
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
