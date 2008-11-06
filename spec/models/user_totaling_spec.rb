require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  define_models do 
    time 2008, 1, 1

    model User do
      stub :totaling, :email=>'totaling@email.com'
    end

    model Item do
      stub :last_year,  :date=>(current_time.to_date - 365), :value=>-1, :user=>users(:totaling), :created_at=>(current_time - 365.days)
      stub :last_month, :date=>(current_time.to_date - 31),  :value=>-1, :user=>users(:totaling), :created_at=>(current_time - 31.days)
      stub :last_week,  :date=>(current_time.to_date - 7),   :value=>-1, :user=>users(:totaling), :created_at=>(current_time - 7.days)
      stub :yesterday,  :date=>(current_time.to_date - 1),   :value=>10, :user=>users(:totaling), :created_at=>(current_time - 1.days)
      stub :today,      :date=>current_time.to_date,         :value=>-1, :user=>users(:totaling), :created_at=>current_time
      stub :tomorrow,   :date=>(current_time.to_date + 1),   :value=>-1, :user=>users(:totaling), :created_at=>(current_time + 1.days)
    end
    
    model Note do
      stub :yesterday,  :date=>(current_time.to_date - 1), :user=>users(:totaling)
      stub :today,      :date=>current_time.to_date,       :user=>users(:totaling)
    end
  end
  before { @user = users(:totaling) }

  #####################################################################
  #                               S T U F F                           #
  #####################################################################
  it 'should find stuff on a day' do
    @user.stuff_during(Date.new(2008, 1, 1)).should == [items(:today), notes(:today)]
  end
  
  it 'should find stuff during a period' do
    @user.stuff_during(Date.new(2007, 12, 31)..Date.new(2008, 1, 1)).should ==
      [ [Date.new(2007, 12, 31), [items(:yesterday), notes(:yesterday)]] , 
        [Date.new(2008, 1, 1),   [items(:today), notes(:today)]]
      ]
  end
  
  it 'should find nothing on an empty day' do
    @user.stuff_during(Date.new(2009, 1, 1)).should == []
  end
  
  it 'should find nothing during an empty period' do
    @user.stuff_during(Date.new(2008, 12, 31)..Date.new(2009, 1, 1)).should == []
  end

  #####################################################################
  #                            T O T A L I N G                        #
  #####################################################################
  it 'should total on a date' do
    @user.total_on(Date.new(2008, 1, 1)).should == -1
  end

  it 'should total for the week' do
    @user.total_past_week(Date.new(2008, 1, 1)).should == 8
  end

  it 'should total this month' do
    @user.total_past_month(Date.new(2008, 1, 1)).should == 7
  end

  it 'should total this year' do
    @user.total_past_year(Date.new(2008, 1, 1)).should == 6
  end

  #####################################################################
  #                            S U M M I N G                          #
  #####################################################################
  it 'should sum income from a range' do
    @user.sum_income(Date.new(2007, 12, 31)..Date.new(2008, 1, 1)).should == 10
  end

  it 'should sum income from a date' do
    @user.sum_income(Date.new(2007, 12, 31)).should == 10
  end

  it 'should sum expenses from a range' do
    @user.sum_expenses(Date.new(2008, 1, 1)..Date.new(2008, 1, 2)).should == -2
  end

  it 'should sum expenses from a date' do
    @user.sum_expenses(Date.new(2008, 1, 1)).should == -1
  end
end