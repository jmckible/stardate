ActionController::Routing::Routes.draw do |map|
  map.resources :items
  map.resources :recurrings
  map.resources :users
  
  map.activity_graph 'graphs/activity.:format/:year/:month/:day/:period',
    :controller  => 'graphs',
    :action      => 'activity',
    :requirement => {:format=>/xml/, :year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year        => nil,
    :month       => nil,
    :day         => nil,
    :period      => nil
    
  map.register 'register/:year/:month/:day/:period',
    :controller   => 'register',
    :action       => 'index',
    :requirements => {:year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year         => nil,
    :month        => nil,
    :day          => nil,
    :period       => nil

  map.with_options :controller=>'sessions' do |s|
    s.login        'login',        :action=>'login'
    s.logout       'logout',       :action=>'logout'
    s.authenticate 'authenticate', :action=>'authenticate', :conditions=>{:method=>:post}
  end
  
  map.root :controller=>'items'
  
end
