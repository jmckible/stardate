require 'rails_helper'

describe TagsController do
  before { login_as :default }

  it 'handles /tags with GET' do
    gt tags_path
    expect(response).to be_success
  end

  it 'handles /tags/:id with GET' do
    gt tags(:default)
    expect(response).to be_success
  end

end
