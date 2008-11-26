ActionController::Routing::Routes.draw do |map|
  map.resources :items
  map.resources :notes
  map.resources :recurrings
  map.resources :runs
  map.resources :sessions
  map.resources :things
  map.resources :users

  map.root :controller=>'things'
  
end
