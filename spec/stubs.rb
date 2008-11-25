ModelStubbing.define_models do 
  
  time 2008, 1, 1
  
  model User do
    stub :email=>'default@email.com', :time_zone=>'Pacific Time (US & Canada)',
         :password_salt=>'salt', :password_hash=>'f438229716cab43569496f3a3630b3727524b81b'
    stub :other, :email=>'other@email.com'
  end
  
  model Vendor do
    stub :name=>'Default'
    stub :other, :name=>'Other'
  end
  
  model Tag do
    stub :name=>'default'
  end
  
  model Recurring do
    stub :day=>1, :value=>-100, :user=>users(:default), :description=>'Recurring', :vendor=>vendors(:default)
    stub :last,   :day=>31, :user=>users(:other)
  end
  
  model Item do
    stub :date=>current_time.to_date, :description=>'What I bought', :value=>-10, 
         :user=>users(:default), :vendor=>vendors(:default), :created_at=>current_time
    stub :other, :user=>users(:other), :recurring=>recurrings(:last)
  end
  
  model Job do
    stub :name=>'Default', :user=>users(:default), :created_at=>current_time,
         :active=>true, :rate=>9.5, :vendor=>vendors(:default)
    stub :other, :user=>users(:other), :vendor=>vendors(:other)
  end
  
  model Note do
    stub :body=>'body', :user=>users(:default), :date=>current_time.to_date, :created_at=>current_time
  end
  
  model Paycheck do
    stub :job=>jobs(:default), :description=>'Got paid', :value=>300, :item=>items(:default)
  end
  
  model Tagging do
    stub :taggable=>items(:default), :taggable_type=>'Item', :tag=>tags(:default)
  end
  
  model Task do
    stub :job=>jobs(:default), :date=>current_time.to_date, :minutes=>60, :paycheck=>paychecks(:default)
    stub :short, :minutes=>30
    stub :long,  :minutes=>120
    stub :other, :job=>jobs(:other), :minutes=>45
  end
  
  model Run do
    stub :user=>users(:default), :distance=>3.5, :date=>current_time.to_date, :created_at=>current_time
  end
  
end