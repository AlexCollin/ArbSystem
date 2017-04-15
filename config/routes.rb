Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'default#index'
  namespace :tracker do
    post '/click', to: 'click#create'
    post '/conversion', to: 'conversion#create'
  end
end
