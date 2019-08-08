Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :courses, except: [:show, :destroy] do
    member do
      get 'client', to: 'courses#client', as: :client
      get 'driver', to: 'courses#driver', as: :driver
      get 'select', to: 'courses#select', as: :select
      get 'start', to: 'courses#start', as: :start
      get 'end', to: 'courses#end', as: :end
    end
  end
  get 'demandes', to: 'courses#demandes', as: :demandes
end
