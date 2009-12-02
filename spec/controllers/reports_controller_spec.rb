require 'spec_helper'

describe ReportsController do
  before { login_as :default }
  
  it 'handles /reports with GET' do
    get :index
    assigns(:start).should == (Date.today - 365)
    assigns(:finish).should == Date.today
    response.should be_success
  end
  
  it 'handles /reports with valid date and GET' do
    get :index, :start=>{:month=>1, :day=>1, :year=>2009}, :finish=>{:month=>2, :day=>2, :year=>2009}
    assigns(:start).should == Date.new(2009, 1, 1)
    assigns(:finish).should == Date.new(2009, 2, 2)
    response.should be_success
  end
  
  it 'handles /reports with invalid date and GET' do
    get :index, :start=>{:month=>1, :day=>41, :year=>2009}, :finish=>{:month=>2, :day=>30, :year=>2009}
    assigns(:start).should == (Date.today - 365)
    assigns(:finish).should == Date.today
    response.should be_success
  end
  
end