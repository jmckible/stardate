require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
  #                                R U N                              #
  #####################################################################
  it 'should parse starting with Ran' do
    run = Grammar.parse 'Ran 4 40'
    run.should be_is_a(Run)
    run.date.should == Time.zone.now.to_date
    run.distance.to_s.should == '4.0'
    run.minutes.should == 40
  end
  
  it 'should parse starting with ran and date' do
    run = Grammar.parse '2/1/09 ran 3.5 45'
    run.should be_is_a(Run)
    run.date.should == Date.new(2009, 2, 1)
    run.distance.to_s.should == '3.5'
    run.minutes.should == 45
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
    item.tag_list.should == ['food', 'sandwich']
  end
  
end