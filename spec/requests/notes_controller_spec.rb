require 'rails_helper'

describe NotesController do
  before { login_as :default }

  it 'handles /notes with GET' do
    get notes_path
    expect(response).to be_successful
  end

  it 'handles /notes/:id with GET' do
    gt notes(:default)
    expect(response).to be_successful
  end

  it 'handles /notes/:id with valid params and PATCH' do
    note = notes(:default)
    ptch note, note: { body: 'update'}
    expect(note.reload.body).to eq('update')
    expect(response).to redirect_to(root_path)
  end

  it 'handles /notes/:id with invalid params and PATCH' do
    note = notes(:default)
    ptch note, note: { body: '' }
    expect(note.reload.body).not_to eq('')
    expect(response).to redirect_to(root_path)
  end

  it 'handles /notes/:id with DELETE' do
    expect {
      del notes(:default)
      expect(response).to redirect_to(root_path)
    }.to change(Note, :count).by(-1)
  end

end
