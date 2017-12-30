require 'rails_helper'

describe ReportsController do
  before { login_as :default }

  it 'handles /reports with GET' do
    gt reports_path
    expect(assigns(:start)).to eq(Time.zone.today - 365)
    expect(assigns(:finish)).to eq(Time.zone.today)
    expect(response).to be_success
  end

  it 'handles /reports with valid date and GET' do
    gt reports_path, start: { month: 1, day: 1, year: 2009}, finish: { month: 2, day: 2, year: 2009 }
    expect(assigns(:start)).to eq(Date.new(2009, 1, 1))
    expect(assigns(:finish)).to eq(Date.new(2009, 2, 2))
    expect(response).to be_success
  end

  it 'handles /reports with invalid date and GET' do
    gt reports_path, start: { month: 1, day: 41, year: 2009 }, finish: { month: 2, day: 30, year: 2009}
    expect(assigns(:start)).to eq(Time.zone.today - 365)
    expect(assigns(:finish)).to eq(Time.zone.today)
    expect(response).to be_success
  end

end
