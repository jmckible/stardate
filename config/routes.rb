Stardate::Application.routes.draw do
  
  resources :accounts do
    get 'fund', :on=>:member
  end
  resources :budgets
  resources :households
  resources :notes
  resources :recurrings
  resources :reports
  resources :sessions
  resources :tags
  resources :things
  resources :transactions
  resources :users
  resources :vendors
  resources :weights
  resources :workouts
  
  get 'date/:year/:month/:day'=>'date#show', as: 'date'

  get 'graphs/health/:start/:finish.:format'=>'graphs#health', as: 'health'
  get 'graphs/spending/:start/:finish.:format'=>'graphs#spending', as: 'spending'

  root to: 'things#index'
  
end
