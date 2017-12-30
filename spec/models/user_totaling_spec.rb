require 'rails_helper'

describe User do
  before { @user = users(:totaling) }

  #####################################################################
  #                            T H I N G S                            #
  #####################################################################
  it 'should find stuff on a day' do
    expect(@user.things_during(Date.new(2008, 1, 1)).size).to eq(3) # [transactions(:today), notes(:today)]
  end

  it 'should find nothing on an empty day' do
    expect(@user.things_during(Date.new(2009, 1, 1))).to eq([])
  end

  #####################################################################
  #                            T O T A L I N G                        #
  #####################################################################
  it 'should total on a date' do
    expect(@user.total_on(Date.new(2008, 1, 1))).to eq(-1)
  end

  it 'should total for the week' do
    expect(@user.total_past_week(Date.new(2008, 1, 1))).to eq(8)
  end

  it 'should total this month' do
    expect(@user.total_past_month(Date.new(2008, 1, 1))).to eq(7)
  end

  it 'should total this year' do
    expect(@user.total_past_year(Date.new(2008, 1, 1))).to eq(6)
  end

  #####################################################################
  #                            S U M M I N G                          #
  #####################################################################
  it 'should encapsulate an amortization' do
    expect(@user.sum_income(Date.new(2007, 12, 20)..Date.new(2008, 1, 1))).to eq(10)
  end

  it 'should be contained within an amortization' do
    expect(@user.sum_income(Date.new(2007, 12, 27)..Date.new(2007, 12, 29))).to eq(0)
  end

  it 'should catch the begining of an amortization' do
    expect(@user.sum_income(Date.new(2007, 12, 20)..Date.new(2007, 12, 24))).to eq(0)
  end

  it 'should cath the end of an amortization' do
    expect(@user.sum_income(Date.new(2007, 12, 30)..Date.new(2008, 1, 3))).to eq(10)
  end

  it 'should sum income from a date' do
    expect(@user.sum_income(Date.new(2007, 12, 25))).to eq(0)
  end

  it 'should sum from a single date as period' do
    expect(@user.sum_income(Date.new(2007, 12, 25)..Date.new(2007, 12, 25))).to eq(0)
  end

  it 'should sum expenses from a range' do
    expect(@user.sum_expenses(Date.new(2008, 1, 1)..Date.new(2008, 1, 2))).to eq(2)
  end

  it 'should sum expenses from a date' do
    expect(@user.sum_expenses(Date.new(2008, 1, 1))).to eq(1)
  end
end
