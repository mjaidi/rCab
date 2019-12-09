Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  scope "(:locale)", locale: /fr|ar/ do
    devise_for :users, :controllers => {:registrations => "registrations"}
    resources :phone_verifications, only: [:new, :create] do
      collection do
        get 'challenge'
        post 'verify'
        get 'success'
      end
    end

    root to: 'pages#home'
    get '/change/:lang', to: 'pages#lang', as: 'lang'

    resources :courses, except: [:index, :show] do
      member do
        get 'client', to: 'courses#client', as: :client
        get 'driver', to: 'courses#driver', as: :driver
        get 'select', to: 'courses#select', as: :select
        get 'start', to: 'courses#start', as: :start
        get 'end', to: 'courses#end', as: :end
        patch 'set_price', to: 'courses#set_price', as: :set_price
      end
    end
    get 'demandes', to: 'courses#demandes', as: :demandes
    get 'dashboard', to: 'courses#dashboard', as: :dashboard
    get 'driver_dashboard', to: 'courses#driver_dashboard', as: :driver_dashboard
  end
end
