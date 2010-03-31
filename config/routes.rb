ActionController::Routing::Routes.draw do |map|
  map.resources :items
  map.resources :notes
  map.resources :recurrings
  map.resources :reports
  map.resources :runs
  map.resources :sessions
  map.resources :tags
  map.resources :things
  map.resources :users
  map.resources :vendors
  
  map.date 'date/:year/:month/:day', :controller=>'date', :action=>'show', :requirements=>{:year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/}
  
  map.with_options :controller=>'graphs' do |g|
    g.running  'graphs/running/:start/:finish.:format',  :action=>'running'
    g.spending 'graphs/spending/:start/:finish.:format', :action=>'spending'
  end

  map.root :controller=>'things'
  
end
