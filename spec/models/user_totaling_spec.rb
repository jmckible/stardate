require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before { @user = users(:totaling) }
  
  #####################################################################
  #                            T H I N G S                            #
  #####################################################################
  it 'should find stuff on a day' do
    @user.things_during(Date.new(2008, 1, 1)).should == [items(:today), notes(:today)]
  end
  
  it 'should find nothing on an empty day' do
    @user.things_during(Date.new(2009, 1, 1)).should == []
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