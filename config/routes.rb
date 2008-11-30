ActionController::Routing::Routes.draw do |map|
  map.resources :items
  map.resources :notes
  map.resources :recurrings
  map.resources :runs
  map.resources :sessions
  map.resources :things
  map.resources :users
  map.resources :vendors
  
  map.with_options :controller=>'graphs', :requirements=>{:format=>/xml/} do |g|
    g.spending_graph 'graphs/spending', :action=>'spending'
  end

  map.root :controller=>'things'
  
end
