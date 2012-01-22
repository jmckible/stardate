Stardate::Application.routes.draw do
  resources :bikes
  resources :ellipticals
  resources :items
  resources :nikes
  resources :notes
  resources :recurrings
  resources :reports
  resources :runs
  resources :sessions
  resources :tags
  resources :things
  resources :users
  resources :vendors
  resources :weights
  
  match 'date/:year/:month/:day'=>'date#show', as: 'date'

  match 'graphs/health/:start/:finish.:format'=>'graphs#health', as: 'health'
  match 'graphs/spending/:start/:finish.:format'=>'graphs#spendign', as: 'spending'

  root to: 'things#index'
  
end
