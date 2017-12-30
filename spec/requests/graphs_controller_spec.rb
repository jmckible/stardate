require 'rails_helper'

describe GraphsController do
  before { login_as :default }

  it 'handles /graphs/health with valid date and GET' do
    gt health_path(start: '2009-01-01', finish: '2009-02-02', format: :xml)
    expect(assigns(:start)).to eq(Date.new(2009, 1, 1))
    expect(assigns(:finish)).to eq(Date.new(2009, 2, 2))
    expect(response).to be_success
  end

  it 'handles /graphs/running with invalid date and GET' do
    gt health_path(start: '2009-01-41', finish: '20090230', format: :xml)
    expect(assigns(:start)).to eq(Time.zone.today - 30)
    expect(assigns(:finish)).to eq(Time.zone.today)
    expect(response).to be_success
  end

  it 'handles /graphs/spending with valid date and GET' do
    gt spending_path(start: '2009-01-01', finish: '2009-02-02', format: :xml)
    expect(assigns(:start)).to eq(Date.new(2009, 1, 1))
    expect(assigns(:finish)).to eq(Date.new(2009, 2, 2))
    expect(response).to be_success
  end

  it 'handles /graphs/spending with invalid date and GET' do
    gt spending_path(start: '2009-01-41', finish: '20090230', format: :xml)
    expect(assigns(:start)).to eq(Time.zone.today - 30)
    expect(assigns(:finish)).to eq(Time.zone.today)
    expect(response).to be_success
  end

end
