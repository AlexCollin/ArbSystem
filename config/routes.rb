Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'default#index'
  namespace :tracker do
    post '/click', to: 'click#create'
    post '/click/page-load', to: 'click#page_load'
    post '/conversion', to: 'conversion#create'
  end
end
