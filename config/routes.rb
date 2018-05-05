Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#home'

  # get '/forecast', to: 'static#forecast'
  # post '/forecast', :to => 'static#forecast'

  # resources :sessions, only: [:new]
  # resources :users, only: [:create, :new, :show] 
  resources :forecasts, only: [:create, :new]
  
  # get '/login', to: 'sessions#new'
  # post '/login', to: 'sessions#create'
  # delete '/logout', to: 'sessions#destroy' 
  # get '/signup', to: 'users#new' 1

end
