require 'rails_helper'

describe Task do
  before { @task = tasks(:default) }
  
  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should belong to a job' do
    expect(@task.job).to eq(jobs(:default))
  end

  it 'should belong to a paycheck' do
    expect(@task.paycheck).to eq(paychecks(:default))
  end

  #####################################################################
  #                            S C O P E                              #
  #####################################################################
  it 'should find by day' do
    expect(Task.on(Date.new(2008, 1, 1)).size).to eq(4)
  end

  it 'should find unpaid' do
    expect(Task.unpaid.size).to eq(0)
  end

  #####################################################################
  #                    O B J E C T    M E T H O D S                   #
  #####################################################################
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
    task = Task.create:date=>Date.today, :job=>jobs(:default), :hours=>1, :min=>20
    expect(task.minutes).to eq(80)
  end

  #####################################################################
  #                       V A L I D A T I O N S                       #
  #####################################################################
  it 'should belong to a job' do
    expect(Task.new).to have(1).error_on(:job_id)
  end

  it 'should have a date' do
    expect(Task.new).to have(1).error_on(:date)
  end
end