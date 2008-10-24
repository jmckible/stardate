module ModelStubbing
  
  define_models do
    time 2008, 1, 1
    
    model Item do
      stub :date=>current_time.to_date, :description=>'What I bought', :value=>-10, 
           :user=>all_stubs(:user), :vendor=>all_stubs(:vendor)
    end
    
    model Job do
      stub :name=>'Default', :user=>all_stubs(:user), :created_at=>current_time,
           :active=>true, :rate=>9.5, :vendor=>all_stubs(:vendor)
    end
    
    model Paycheck do
      stub :job=>all_stubs(:job), :description=>'Got paid', :value=>300, :item=>all_stubs(:item)
    end
    
    model Recurring do
      stub :day=>1, :value=>-100, :user=>all_stubs(:user), :description=>'Recurring'
    end
    
    model Tagging do
      stub :taggable=>all_stubs(:item), :tag=>all_stubs(:tag)
    end
    
    model Tag do
      stub :name=>'default'
    end
    
    model Task do
      stub :job=>all_stubs(:job), :date=>current_time.to_date, :minutes=>60, :paycheck=>all_stubs(:paycheck)
    end
    
    model User do
      stub :email=>'default@email.com', :time_zone=>'Pacific Time (US & Canada)',
           :password_salt=>'salt', :password_hash=>'f438229716cab43569496f3a3630b3727524b81b'
    end
    
    model Vendor do
      stub :name=>'Default'
    end
  end
  
end