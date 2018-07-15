Rails.application.routes.draw do
  get '/reports' => 'reports#all'
  root 'users#index'
  get '/signin' => 'users#new'
  resources :users
  post '/signin',  to: 'users#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
