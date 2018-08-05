Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root 'reports#home'
  get '/reports/all' => 'reports#all'
  get '/signin' => 'users#new'
  get    '/login'   => 'sessions#new'
  post   '/login'   => 'sessions#create'
  delete '/logout'  => 'sessions#destroy'
  resources :users
  resources :account_activations, only:[:edit]
  resources :password_resets,     only:[:new, :create, :edit, :update]
  resources :dailyreports,        only:[:create, :edit, :delete, :update]
  delete '/dailyreports/:id'  => 'dailyreports#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
