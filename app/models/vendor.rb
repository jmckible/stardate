class Vendor < ActiveRecord::Base
  
  has_many :items, :order=>'created_at desc' do
    
    def from(user)
      find :all, :conditions=>{:user_id=>user.id}
    end
    
    def count_from(user)
      count :conditions=>{:user_id=>user.id}
    end
    
    def sum_from(user)
      sum :value, :conditions=>{:user_id=>user.id}
    end
    
  end
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
end
