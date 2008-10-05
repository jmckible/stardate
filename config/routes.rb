ActionController::Routing::Routes.draw do |map|
  ##########################
  #      G R A P H S       #
  ##########################
  map.activity_graph 'graphs/activity.:format/:year/:month/:day/:period',
    :controller=>'graphs',
    :action=>'activity',
    :requirement=>{:format=>/xml/, :year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year=>nil,
    :month=>nil,
    :day=>nil,
    :period=>nil
  
  map.in_out_bar_graph 'graphs/in_out_bar.:format/:year/:month/:day/:period',
    :controller=>'graphs',
    :action=>'in_out_bar',
    :requirement=>{:format=>/xml/, :year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year=>nil,
    :month=>nil,
    :day=>nil,
    :period=>nil
    
  map.tag_bubble_graph 'graphs/tag_bubble.:format/:year/:month/:day/:period',
    :controller=>'graphs',
    :action=>'tag_bubble',
    :requirement=>{:format=>/xml/, :year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year=>nil,
    :month=>nil,
    :day=>nil,
    :period=>nil
    
  ##########################
  #   R E S O U R C E S    #
  ##########################  
  map.resources :items
  map.resources :jobs, :has_many=>:paychecks
  map.resources :recurrings
  map.resources :tasks
  map.resources :users
    
  ##########################
  #       L O G I N        #
  ##########################
  map.login 'login', :controller=>'sessions', :action=>'login'
  map.logout 'logout', :controller=>'sessions', :action=>'logout'
  map.authenticate 'authenticate', :controller=>'sessions', :action=>'authenticate', :conditions=>{:method=>:post}
  
  ##########################
  #        H O M E         #
  ##########################
  map.home 'home', :controller=>'home'
  map.register 'register/:year/:month/:day/:period',
    :controller=>'register',
    :action=>'index',
    :requirements=>{:year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/, :period=>/\d+/},
    :year=>nil,
    :month=>nil,
    :day=>nil,
    :period=>nil
  map.welcome '', :controller=>'public'
end
