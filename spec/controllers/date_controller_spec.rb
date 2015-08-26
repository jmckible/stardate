require 'rails_helper'

describe DateController do
  before { login_as :default }

  it 'handles /date/:year/:month/:day with valid date and GET' do
    get :show, year: 2008, month: 1, day: 1
    expect(assigns(:date)).to eq(Date.new(2008, 1, 1))
    expect(response).to be_success
  end

  it 'handles /date/:year/:month/:day with invalid date and GET' do
    get :show, year: 2008, month: 2, day: 30
    expect(response.response_code).to eq(404)
  end

end
