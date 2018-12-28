require 'rails_helper'

describe UsersController do
  before { login_as :default }

  it 'handles /users/:id/edit with GET' do
    gt [:edit, @current_user]
    expect(response).to be_successful
  end

  it 'handles /users/:id with valid params and PATCH' do
    ptch @current_user, user: { email: 'new@email.com' }
    expect(@current_user.reload.email).to eq('new@email.com')
    expect(response).to redirect_to(edit_user_path(@current_user))
  end

  it 'handles /users/:id with invalid params and PATCH' do
    ptch @current_user, user: {email: ''}
    expect(@current_user.reload.email).not_to be_blank
    expect(response).to render_template(:edit)
    expect(response).to be_successful
  end

end
