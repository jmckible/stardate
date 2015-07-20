require 'rails_helper'

describe Task do
  before { @task = tasks(:default) }

  it 'should derive hours and min with null minutes' do
    task = Task.new
    expect(task.hours).to be_nil
    expect(task.min).to eq('00')
  end

  it 'should derive hours and min with less than 60 minutes' do
    task = tasks(:short)
    expect(task.hours).to be_nil
    expect(task.min).to eq(30)
  end

  it 'should derive hours and min with more than 60 minutes' do
    task = tasks(:long)
    expect(task.hours).to eq(2)
    expect(task.min).to eq('00')
  end

  it 'should over write just hours' do
    task = tasks(:short)
    task.hours = 2
    task.save
    task.reload
    expect(task.minutes).to eq(120)
  end

  it 'should overwrite hours and min' do
    task = tasks(:short)
    task.hours = 1
    task.min = 20
    task.save
    task.reload
    expect(task.minutes).to eq(80)
  end

  it 'should overwrite just minutes' do
    task = tasks(:long)
    task.min = 40
    task.save
    task.reload
    expect(task.minutes).to eq(40)
  end

  it 'should set hours and min for a new task' do
    task = Task.create date: Date.today, job: jobs(:default), hours: 1, min: 20
    expect(task.minutes).to eq(80)
  end

end
