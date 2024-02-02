Rails.application.routes.draw do
  resources :users, only: [:create] do
    collection do
      post '/login', to: 'users#login'
    end
  end

  resources :meccas, only: [:show, :create, :update, :destroy] do
    resources :favorites, only: [:create, :destroy ]
    collection do
      get '/prefecture/:prefecture', to: 'meccas#prefecture'
    end
  end
end
