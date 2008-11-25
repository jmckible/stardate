ActionController::Routing::Routes.draw do |map|
  map.resources :items
  map.resources :notes
  map.resources :recurrings
  map.resources :runs
  map.resources :sessions
  map.resources :things
  map.resources :users
    
  map.register 'register/:year/:month/:day/:period',
    :controller   => 'register',
    :action       => 'index',
    :requirements => {:year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year         => nil,
    :month        => nil,
    :day          => nil,
    :period       => nil
  
  map.root :controller=>'things'
  
end
