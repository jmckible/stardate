require 'rails_helper'

describe Note do
  before { @note = notes(:default) }
  
  it 'should belong to a user' do
    expect(@note.user).to eq(users(:default))
  end
  
  it 'should have a body' do
    expect(Note.new).to have(1).error_on(:body)
  end
  
  it 'should have a date' do
    expect(Note.new).to have(1).error_on(:date)
  end
  
  it 'should belong to a user' do
    expect(Note.new).to have(1).error_on(:user_id)
  end
end
