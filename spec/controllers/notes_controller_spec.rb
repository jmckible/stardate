require 'rails_helper'

describe NotesController do
  before { login_as :default }

  it 'handles /notes with GET' do
    get :index
    expect(response).to be_success
  end

  it 'handles /notes/:id with GET' do
    get :show, :id=>notes(:default)
    expect(response).to be_success
  end

  it 'handles /notes/:id with valid params and PUT' do
    note = notes(:default)
    put :update, :id=>note, :note=>{:body=>'update'}
    expect(note.reload.body).to eq('update')
    expect(response).to redirect_to(root_path)
  end

  it 'handles /notes/:id with invalid params and PUT' do
    note = notes(:default)
    put :update, :id=>note, :note=>{:body=>''}
    expect(note.reload.body).not_to eq('')
    expect(response).to redirect_to(root_path)
  end

  it 'handles /notes/:id with DELETE' do
    expect(running {
      delete :destroy, :id=>notes(:default)
      expect(response).to redirect_to(root_path)
    }).to change(Note, :count).by(-1)
  end

end
