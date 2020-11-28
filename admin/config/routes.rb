Admin::Engine.routes.draw do
  root to: 'dashboard#index'
  get '/auth/callback' => 'auth#callback'
  resources :dashboard, controller: :dashboard, only: :index
  resource :session, only: :destroy
end
