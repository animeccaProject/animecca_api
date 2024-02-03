Rails.application.routes.draw do
  # users関係
  resources :users, only: [:create] do
    collection do
      post '/login', to: 'users#login'
    end
  end

  # 階層が一個上がるので、meccasのルーティングから外しました
  # (mecca_idを指定しないルーティングにしました)
  get '/favorites', to: 'favorites#index'

  resources :meccas, only: [:show, :create, :update, :destroy] do
    # favorite_idが末尾につくので、favorite_idを指定しないルーティングにしました
    post '/favorites', to: 'favorites#create'
    delete '/favorites', to: 'favorites#destroy'
    # prefecture
    collection do
      get '/prefecture/:prefecture', to: 'meccas#prefecture'
    end
  end
end
