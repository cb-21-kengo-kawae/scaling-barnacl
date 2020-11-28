Rails.application.routes.draw do
  root 'vue_application#index'

  get '/auth/callback' => 'auth#callback'

  resource :session, only: :destroy

  namespace :ajax do
    resources :policy, only: [:index]
    resources :account_users, only: [:index]

    namespace :front do
      get '/firebase_token' => 'firebase#token'
    end
  end

  get 'select_todo', to: 'vue_application#index', as: :loggedin

  mount Api::Root => '/api'

  # Admin
  mount Admin::Engine => '/admin'

  mount Fs::Zeldalogging::Engine => '/zeldalogging'

  scope '/app' do
    # Health Check
    get 'healthcheck', to: 'informations#health_check'

    # System Check
    get 'databasecheck', to: 'informations#database_check'
    get 'benchmarkcheck', to: 'informations#benchmark_check'
    # System Information
    get 'info', to: 'informations#index'
  end

  if Rails.env.integration? || Rails.env.development? || Rails.env.test?
    mount GrapeSwaggerRails::Engine => '/swagger'
  end
end
