require 'rails_helper'

describe GraphsController do
  before do
    login_as :default
    @request.env['HTTP_ACCEPT'] = 'application/xml'
  end

  it 'handles /graphs/health with valid date and GET' do
    get :health, :start=>'2009-01-01', :finish=>'2009-02-02', :format=>:xml
    assigns(:start).should == Date.new(2009, 1, 1)
    assigns(:finish).should == Date.new(2009, 2, 2)
    response.should be_success
  end

  it 'handles /graphs/running with invalid date and GET' do
    get :health, :start=>'2009-01-41', :finish=>'20090230', :format=>:xml
    assigns(:start).should == (Date.today - 30)
    assigns(:finish).should == Date.today
    response.should be_success
  end

  it 'handles /graphs/spending with valid date and GET' do
    get :spending, :start=>'2009-01-01', :finish=>'2009-02-02', :format=>:xml
    assigns(:start).should == Date.new(2009, 1, 1)
    assigns(:finish).should == Date.new(2009, 2, 2)
    response.should be_success
  end

  it 'handles /graphs/spending with invalid date and GET' do
    get :spending, :start=>'2009-01-41', :finish=>'20090230', :format=>:xml
    assigns(:start).should == (Date.today - 30)
    assigns(:finish).should == Date.today
    response.should be_success
  end

end
