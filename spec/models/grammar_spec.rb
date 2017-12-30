require 'rails_helper'

describe Grammar do

  #####################################################################
  #                               D A T E                             #
  #####################################################################
  it 'should parse a date with nothing' do
    expect(Grammar.parse_date).to eq(Time.zone.now.to_date)
  end

  it 'should parse a date with month and day' do
    expect(Grammar.parse_date('1/2')).to eq(Date.new(Time.zone.today.year, 1, 2))
  end

  it 'should parse a date with mdy' do
    expect(Grammar.parse_date('1/2/03')).to eq(Date.new(2003, 1, 2))
    expect(Grammar.parse_date('1/2/2003')).to eq(Date.new(2003, 1, 2))
  end

  it 'should handle an invalid date' do
    expect(Grammar.parse_date('32')).to      eq(Time.zone.now.to_date)
    expect(Grammar.parse_date('13/1')).to    eq(Time.zone.now.to_date)
    expect(Grammar.parse_date('14/7/08')).to eq(Time.zone.now.to_date)
  end

  #####################################################################
  #                                N O T E                            #
  #####################################################################
  it 'should parse an empty string' do
    note = Grammar.parse '', households(:default)
    expect(note).to be_is_a(Note)
    expect(note.date).to eq(Time.zone.now.to_date)
    expect(note.body).to be_blank
  end

  it 'should parse a note with just body' do
    note = Grammar.parse 'body', households(:default)
    expect(note).to be_is_a(Note)
    expect(note.date).to eq(Time.zone.now.to_date)
    expect(note.body).to eq('body')
  end

  it 'should parse a note that starts with a number' do
    note = Grammar.parse '4 is a number', households(:default)
    expect(note).to be_is_a(Note)
    expect(note.date).to eq(Time.zone.now.to_date)
    expect(note.body).to eq('4 is a number')
  end

  it 'should parse a note with date and body' do
    note = Grammar.parse '2/1/2009 something happened', households(:default)
    expect(note).to be_is_a(Note)
    expect(note.date).to eq(Date.new(2009, 2, 1))
    expect(note.body).to eq('something happened')
  end

  #####################################################################
  #                              B I K E                              #
  #####################################################################
  it 'should parse starting with Bike' do
    bike = Grammar.parse 'Bike 5 50', households(:default)
    expect(bike).to be_is_a(Workout)
    expect(bike).to be_bike
    expect(bike.date).to eq(Time.zone.now.to_date)
    expect(bike.distance.to_s).to eq('5.0')
    expect(bike.minutes).to eq(50)
  end

  it 'should parse starting with b' do
    bike = Grammar.parse 'b 5 50', households(:default)
    expect(bike).to be_is_a(Workout)
    expect(bike).to be_bike
    expect(bike.date).to eq(Time.zone.now.to_date)
    expect(bike.distance.to_s).to eq('5.0')
    expect(bike.minutes).to eq(50)
  end

  it 'should parse starting with ran and date' do
    bike = Grammar.parse '2/1/09 bike 4.5 60', households(:default)
    expect(bike).to be_is_a(Workout)
    expect(bike).to be_bike
    expect(bike.date).to eq(Date.new(2009, 2, 1))
    expect(bike.distance.to_s).to eq('4.5')
    expect(bike.minutes).to eq(60)
  end

  #####################################################################
  #                        E L L I P T I C A L                        #
  #####################################################################
  it 'should parse starting with Elliptical' do
    elliptical = Grammar.parse 'Elliptical 2 20', households(:default)
    expect(elliptical).to be_is_a(Workout)
    expect(elliptical).to be_elliptical
    expect(elliptical.date).to eq(Time.zone.now.to_date)
    expect(elliptical.distance.to_s).to eq('2.0')
    expect(elliptical.minutes).to eq(20)
  end

  it 'should parse starting with e' do
    elliptical = Grammar.parse 'e 1 10', households(:default)
    expect(elliptical).to be_is_a(Workout)
    expect(elliptical).to be_elliptical
    expect(elliptical.date).to eq(Time.zone.now.to_date)
    expect(elliptical.distance.to_s).to eq('1.0')
    expect(elliptical.minutes).to eq(10)
  end

  it 'should parse starting with ran and date' do
    elliptical = Grammar.parse '2/1/09 elliptical 4.5 60', households(:default)
    expect(elliptical).to be_is_a(Workout)
    expect(elliptical).to be_elliptical
    expect(elliptical.date).to eq(Date.new(2009, 2, 1))
    expect(elliptical.distance.to_s).to eq('4.5')
    expect(elliptical.minutes).to eq(60)
  end

  #####################################################################
  #                               N I K E                             #
  #####################################################################
  it 'should parse starting with Nike' do
    nike = Grammar.parse 'Nike 45 Advanced - trainer', households(:default)
    expect(nike).to be_is_a(Workout)
    expect(nike).to be_nike
    expect(nike.date).to eq(Time.zone.now.to_date)
    expect(nike.minutes).to eq(45)
    expect(nike.description).to eq('Advanced - trainer')
  end

  it 'should parse starting with n' do
    nike = Grammar.parse 'n 40 strength', households(:default)
    expect(nike).to be_is_a(Workout)
    expect(nike).to be_nike
    expect(nike.date).to eq(Time.zone.now.to_date)
    expect(nike.minutes).to eq(40)
    expect(nike.description).to eq('strength')
  end

  it 'should parse starting with nike and date' do
    nike = Grammar.parse '2/1/09 nike 45 lean strong', households(:default)
    expect(nike).to be_is_a(Workout)
    expect(nike).to be_nike
    expect(nike.date).to eq(Date.new(2009, 2, 1))
    expect(nike.minutes).to eq(45)
    expect(nike.description).to eq('lean strong')
  end

  #####################################################################
  #                               P 9 0 X                             #
  #####################################################################
  it 'should parse starting with P90X' do
    p90x = Grammar.parse 'P90X 60 Back', households(:default)
    expect(p90x).to be_is_a(Workout)
    expect(p90x).to be_p90x
    expect(p90x.date).to eq(Time.zone.now.to_date)
    expect(p90x.minutes).to eq(60)
    expect(p90x.description).to eq('Back')
  end

  it 'should parse starting with p' do
    p90x = Grammar.parse 'p 90 yoga', households(:default)
    expect(p90x).to be_is_a(Workout)
    expect(p90x).to be_p90x
    expect(p90x.date).to eq(Time.zone.now.to_date)
    expect(p90x.minutes).to eq(90)
    expect(p90x.description).to eq('yoga')
  end

  it 'should parse starting with p90x and date' do
    p90x = Grammar.parse '2/1/09 p90x 60 plyo', households(:default)
    expect(p90x).to be_is_a(Workout)
    expect(p90x).to be_p90x
    expect(p90x.date).to eq(Date.new(2009, 2, 1))
    expect(p90x.minutes).to eq(60)
    expect(p90x.description).to eq('plyo')
  end

  #####################################################################
  #                                R U N                              #
  #####################################################################
  it 'should parse starting with Ran' do
    run = Grammar.parse 'Ran 4 40', households(:default)
    expect(run).to be_is_a(Workout)
    expect(run).to be_run
    expect(run.date).to eq(Time.zone.now.to_date)
    expect(run.distance.to_s).to eq('4.0')
    expect(run.minutes).to eq(40)
  end

  it 'should parse starting with r' do
    run = Grammar.parse 'r 4 40', households(:default)
    expect(run).to be_is_a(Workout)
    expect(run).to be_run
    expect(run.date).to eq(Time.zone.now.to_date)
    expect(run.distance.to_s).to eq('4.0')
    expect(run.minutes).to eq(40)
  end

  it 'should parse starting with ran and date' do
    run = Grammar.parse '2/1/09 ran 3.5 45', households(:default)
    expect(run).to be_is_a(Workout)
    expect(run).to be_run
    expect(run.date).to eq(Date.new(2009, 2, 1))
    expect(run.distance.to_s).to eq('3.5')
    expect(run.minutes).to eq(45)
  end

  #####################################################################
  #                              W A L K                              #
  #####################################################################
  it 'should parse starting with Walk' do
    run = Grammar.parse 'Walk 4 40', households(:default)
    expect(run).to be_is_a(Workout)
    expect(run).to be_walk
    expect(run.date).to eq(Time.zone.now.to_date)
    expect(run.distance.to_s).to eq('4.0')
    expect(run.minutes).to eq(40)
  end

  it 'should parse starting with walk and date' do
    run = Grammar.parse '2/1/09 walk 3.5 45', households(:default)
    expect(run).to be_is_a(Workout)
    expect(run).to be_walk
    expect(run.date).to eq(Date.new(2009, 2, 1))
    expect(run.distance.to_s).to eq('3.5')
    expect(run.minutes).to eq(45)
  end

  #####################################################################
  #                            W E I G H T                            #
  #####################################################################
  it 'should parse starting with weight' do
    weight = Grammar.parse 'weight 150.2', households(:default)
    expect(weight).to be_is_a(Weight)
    expect(weight.date).to eq(Time.zone.now.to_date)
    expect(weight.weight).to eq(150.2)
  end

  it 'should parse starting with w' do
    weight = Grammar.parse 'w 150', households(:default)
    expect(weight).to be_is_a(Weight)
    expect(weight.date).to eq(Time.zone.now.to_date)
    expect(weight.weight).to eq(150)
  end

  it 'should parse starting with weight and date' do
    weight = Grammar.parse '2/1/09 weight 150.2', households(:default)
    expect(weight).to be_is_a(Weight)
    expect(weight.date).to eq(Date.new(2009, 2, 1))
    expect(weight.weight).to eq(150.2)
  end

  #####################################################################
  #                              I T E M                              #
  #####################################################################
  it 'should parse just an assumed negative amount' do
    transaction = Grammar.parse "$4", households(:default)
    expect(transaction).to be_is_a(Transaction)
    expect(transaction.date).to eq(Time.zone.now.to_date)
    expect(transaction.amount).to eq(4)
    expect(transaction.vendor).to be_nil
    expect(transaction.description).to be_nil
  end

  it 'should parse just a positive amount' do
    transaction = Grammar.parse "+$4", households(:default)
    expect(transaction).to be_is_a(Transaction)
    expect(transaction.date).to eq(Time.zone.now.to_date)
    expect(transaction.amount).to eq(4)
    expect(transaction.vendor).to be_nil
    expect(transaction.description).to be_nil
  end

  it 'should parse a date and a amount' do
    transaction = Grammar.parse "5/6 $10", households(:default)
    expect(transaction).to be_is_a(Transaction)
    expect(transaction.date).to eq(Date.new(Time.zone.now.to_date.year, 5, 6))
    expect(transaction.amount).to eq(10)
    expect(transaction.vendor).to be_nil
    expect(transaction.description).to be_nil
  end

  it 'should parse a amount and a vendor' do
    transaction = Grammar.parse "$10 Target", households(:default)
    expect(transaction).to be_is_a(Transaction)
    expect(transaction.date).to eq(Time.zone.now.to_date)
    expect(transaction.amount).to eq(10)
    expect(transaction.vendor.name).to eq('Target')
    expect(transaction.description).to be_nil
  end

  it 'should parse a amount, vendor, and description' do
    transaction = Grammar.parse "+$20 Home Depot - lampshades", households(:default)
    expect(transaction).to be_is_a(Transaction)
    expect(transaction.date).to eq(Time.zone.now.to_date)
    expect(transaction.amount).to eq(20)
    expect(transaction.vendor.name).to eq('Home Depot')
    expect(transaction.description).to eq('lampshades')
  end

  it 'should parse a date, amount, vendor, description, and tags' do
    transaction = Grammar.parse "1/2/03 $5 Kool Korners - cuban [food, sandwich]", households(:default)
    expect(transaction).to be_is_a(Transaction)
    expect(transaction.date).to eq(Date.new(2003, 1, 2))
    expect(transaction.amount).to eq(5)
    expect(transaction.vendor.name).to eq('Kool Korners')
    expect(transaction.description).to eq('cuban')
  end

end
