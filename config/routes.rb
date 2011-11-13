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
  
  #date 'date/:year/:month/:day', :controller=>'date', :action=>'show', :requirements=>{:year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/}
  match 'date/:year/:month/:day'=>'date#show', as: 'date'
  
  # with_options :controller=>'graphs' do |g|
  #   g.health   'graphs/health/:start/:finish.:format',     :action=>'health'
  #   g.spending 'graphs/spending/:start/:finish.:format',   :action=>'spending'
  # end
  match 'graphs/health/:start/:finish.:format'=>'graphs#health', as: 'health'
  match 'graphs/spending/:start/:finish.:format'=>'graphs#spendign', as: 'spending'

  root to: 'things#index'
  
end
