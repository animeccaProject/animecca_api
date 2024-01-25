Rails.application.routes.draw do
  resources :users, only: [:create] do
    post '/login', to: 'user#login'
  end
end
