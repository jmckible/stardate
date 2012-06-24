require 'spec_helper'

describe Grammar do
  
  #####################################################################
  #                               D A T E                             #
  #####################################################################
  it 'should parse a date with nothing' do
    Grammar.parse_date.should == Time.zone.now.to_date
  end
    
  it 'should parse a date with month and day' do
    Grammar.parse_date('1/2').should   == Date.new(Date.today.year, 1, 2)
  end
  
  it 'should parse a date with mdy' do
    Grammar.parse_date('1/2/03').should   == Date.new(2003, 1, 2)
    Grammar.parse_date('1/2/2003').should == Date.new(2003, 1, 2)
  end
  
  it 'should handle an invalid date' do
    Grammar.parse_date('32').should      == Time.zone.now.to_date
    Grammar.parse_date('13/1').should    == Time.zone.now.to_date
    Grammar.parse_date('14/7/08').should == Time.zone.now.to_date
  end
  
  
  #####################################################################
  #                                N O T E                            #
  #####################################################################
  it 'should parse an empty string' do
    note = Grammar.parse ''
    note.should be_is_a(Note)
    note.date.should == Time.zone.now.to_date
    note.body.should be_blank
  end
  
  it 'should parse a note with just body' do
    note = Grammar.parse 'body'
    note.should be_is_a(Note)
    note.date.should == Time.zone.now.to_date
    note.body.should == 'body'
  end
  
  it 'should parse a note that starts with a number' do
    note = Grammar.parse '4 is a number'
    note.should be_is_a(Note)
    note.date.should == Time.zone.now.to_date
    note.body.should == '4 is a number'
  end
  
  it 'should parse a note with date and body' do
    note = Grammar.parse '2/1/2009 something happened'
    note.should be_is_a(Note)
    note.date.should == Date.new(2009, 2, 1)
    note.body.should == 'something happened'
  end
  
  #####################################################################
  #                              B I K E                              #
  #####################################################################
  it 'should parse starting with Bike' do
    bike = Grammar.parse 'Bike 5 50'
    bike.should be_is_a(Workout)
    bike.should be_bike
    bike.date.should == Time.zone.now.to_date
    bike.distance.to_s.should == '5.0'
    bike.minutes.should == 50
  end
  
  it 'should parse starting with b' do
    bike = Grammar.parse 'b 5 50'
    bike.should be_is_a(Workout)
    bike.should be_bike
    bike.date.should == Time.zone.now.to_date
    bike.distance.to_s.should == '5.0'
    bike.minutes.should == 50
  end
  
  it 'should parse starting with ran and date' do
    bike = Grammar.parse '2/1/09 bike 4.5 60'
    bike.should be_is_a(Workout)
    bike.should be_bike
    bike.date.should == Date.new(2009, 2, 1)
    bike.distance.to_s.should == '4.5'
    bike.minutes.should == 60
  end
  
  #####################################################################
  #                        E L L I P T I C A L                        #
  #####################################################################
  it 'should parse starting with Elliptical' do
    elliptical = Grammar.parse 'Elliptical 2 20'
    elliptical.should be_is_a(Workout)
    elliptical.should be_elliptical
    elliptical.date.should == Time.zone.now.to_date
    elliptical.distance.to_s.should == '2.0'
    elliptical.minutes.should == 20
  end
  
  it 'should parse starting with e' do
    elliptical = Grammar.parse 'e 1 10'
    elliptical.should be_is_a(Workout)
    elliptical.should be_elliptical
    elliptical.date.should == Time.zone.now.to_date
    elliptical.distance.to_s.should == '1.0'
    elliptical.minutes.should == 10
  end
  
  it 'should parse starting with ran and date' do
    elliptical = Grammar.parse '2/1/09 elliptical 4.5 60'
    elliptical.should be_is_a(Workout)
    elliptical.should be_elliptical
    elliptical.date.should == Date.new(2009, 2, 1)
    elliptical.distance.to_s.should == '4.5'
    elliptical.minutes.should == 60
  end
  
  #####################################################################
  #                               N I K E                             #
  #####################################################################
  it 'should parse starting with Nike' do
    nike = Grammar.parse 'Nike 45 Advanced - trainer'
    nike.should be_is_a(Workout)
    nike.should be_nike
    nike.date.should == Time.zone.now.to_date
    nike.minutes.should == 45
    nike.description.should == 'Advanced - trainer'
  end
  
  it 'should parse starting with n' do
    nike = Grammar.parse 'n 40 strength'
    nike.should be_is_a(Workout)
    nike.should be_nike
    nike.date.should == Time.zone.now.to_date
    nike.minutes.should == 40
    nike.description.should == 'strength'
  end
  
  it 'should parse starting with nike and date' do
    nike = Grammar.parse '2/1/09 nike 45 lean strong'
    nike.should be_is_a(Workout)
    nike.should be_nike
    nike.date.should == Date.new(2009, 2, 1)
    nike.minutes.should == 45
    nike.description.should == 'lean strong'
  end
  
  #####################################################################
  #                               P 9 0 X                             #
  #####################################################################
  it 'should parse starting with P90X' do
    p90x = Grammar.parse 'P90X 60 Back'
    p90x.should be_is_a(Workout)
    p90x.should be_p90x
    p90x.date.should == Time.zone.now.to_date
    p90x.minutes.should == 60
    p90x.description.should == 'Back'
  end
  
  it 'should parse starting with p' do
    p90x = Grammar.parse 'p 90 yoga'
    p90x.should be_is_a(Workout)
    p90x.should be_p90x
    p90x.date.should == Time.zone.now.to_date
    p90x.minutes.should == 90
    p90x.description.should == 'yoga'
  end
  
  it 'should parse starting with p90x and date' do
    p90x = Grammar.parse '2/1/09 p90x 60 plyo'
    p90x.should be_is_a(Workout)
    p90x.should be_p90x
    p90x.date.should == Date.new(2009, 2, 1)
    p90x.minutes.should == 60
    p90x.description.should == 'plyo'
  end
  
  #####################################################################
  #                                R U N                              #
  #####################################################################
  it 'should parse starting with Ran' do
    run = Grammar.parse 'Ran 4 40'
    run.should be_is_a(Workout)
    run.should be_run
    run.date.should == Time.zone.now.to_date
    run.distance.to_s.should == '4.0'
    run.minutes.should == 40
  end
  
  it 'should parse starting with r' do
    run = Grammar.parse 'r 4 40'
    run.should be_is_a(Workout)
    run.should be_run
    run.date.should == Time.zone.now.to_date
    run.distance.to_s.should == '4.0'
    run.minutes.should == 40
  end
  
  it 'should parse starting with ran and date' do
    run = Grammar.parse '2/1/09 ran 3.5 45'
    run.should be_is_a(Workout)
    run.should be_run
    run.date.should == Date.new(2009, 2, 1)
    run.distance.to_s.should == '3.5'
    run.minutes.should == 45
  end
  
  #####################################################################
  #                            W E I G H T                            #
  #####################################################################
  it 'should parse starting with weight' do
    weight = Grammar.parse 'weight 150.2'
    weight.should be_is_a(Weight)
    weight.date.should == Time.zone.now.to_date
    weight.weight.should == 150.2
  end
  
  it 'should parse starting with w' do
    weight = Grammar.parse 'w 150'
    weight.should be_is_a(Weight)
    weight.date.should == Time.zone.now.to_date
    weight.weight.should == 150
  end
  
  it 'should parse starting with weight and date' do
    weight = Grammar.parse '2/1/09 weight 150.2'
    weight.should be_is_a(Weight)
    weight.date.should == Date.new(2009, 2, 1)
    weight.weight.should == 150.2
  end
  
  #####################################################################
  #                              I T E M                              #
  #####################################################################
  it 'should parse just an assumed negative value' do
    item = Grammar.parse "$4"
    item.should be_is_a(Item)
    item.date.should == Time.zone.now.to_date
    item.value.should == -4
    item.vendor.should be_nil
    item.description.should be_nil
    item.should have(0).tags
  end
  
  it 'should parse just a positive value' do
    item = Grammar.parse "+$4"
    item.should be_is_a(Item)
    item.date.should == Time.zone.now.to_date
    item.value.should == 4
    item.vendor.should be_nil
    item.description.should be_nil
    item.should have(0).tags
  end
  
  it 'should parse a date and a value' do
    item = Grammar.parse "5/6 $10"
    item.should be_is_a(Item)
    item.date.should == Date.new(Time.zone.now.to_date.year, 5, 6)
    item.value.should == -10
    item.vendor.should be_nil
    item.description.should be_nil
    item.should have(0).tags
  end
  
  it 'should parse a value and a vendor' do
    item = Grammar.parse "$10 Target"
    item.should be_is_a(Item)
    item.date.should == Time.zone.now.to_date
    item.value.should == -10
    item.vendor.name.should == 'Target'
    item.description.should be_nil
    item.should have(0).tags
  end
  
  it 'should parse a value, vendor, and description' do
    item = Grammar.parse "+$20 Home Depot - lampshades"
    item.should be_is_a(Item)
    item.date.should == Time.zone.now.to_date
    item.value.should == 20
    item.vendor.name.should == 'Home Depot'
    item.description.should == 'lampshades'
    item.should have(0).tags
  end
  
  it 'should parse a date, value, vendor, description, and tags' do
    item = Grammar.parse "1/2/03 $5 Kool Korners - cuban [food, sandwich]"
    item.should be_is_a(Item)
    item.date.should == Date.new(2003, 1, 2)
    item.value.should == -5
    item.vendor.name.should == 'Kool Korners'
    item.description.should == 'cuban'
    item.should have(2).tags
  end
  
end