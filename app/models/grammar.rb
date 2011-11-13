class Grammar
  
  def self.parse(string)
    date     = Grammar.parse_date string.slice!(/^\d+\/\d+(\/\d+)?\s/)
    tag_list = (string.slice!(/\s\[.+\]$/) || '').gsub(/(^\s\[)|(\]$)/, '')

    if string =~ /^(\$|\+)/
      words = string.split ' '
      explicit_value = words.shift.gsub('$', '')
      string = words.join ' '
      if string =~ /-/
        words  = string.split ' - '
        vendor = words.shift
        description = words.join ' - '
      else
        vendor = string
      end
      Item.new date: date, explicit_value: explicit_value, vendor_name: vendor, 
               description: description, tag_list: tag_list
               
    elsif string =~ /^(Bike|bike|b )/
      distance, minutes = string.split(/^(Bike|bike|b) /).last.split(' ')
      Bike.new date: date, distance: distance, minutes: minutes
    elsif string =~ /^(Elliptical|elliptical|e )/
      distance, minutes = string.split(/^(Elliptical|elliptical|e) /).last.split(' ')
      Elliptical.new date: date, distance: distance, minutes: minutes
    elsif string =~ /^(Ran|ran|r )/
      distance, minutes = string.split(/^(Ran|ran|r) /).last.split(' ')
      Run.new date: date, distance: distance, minutes: minutes
    elsif string =~ /^(weight|w )/
      weight = string.split(/^(weight |w )/).last
      Weight.new date: date, weight: weight
    else
      Note.new date: date, body: string
    end
  rescue
    Note.new date: Time.zone.now.to_date, body: 'Failed to parse'
  end
  
  def self.parse_date(string=nil)
    return Time.zone.now.to_date if string.nil?
    pieces = string.strip.split('/').collect(&:to_i)
    case pieces.length
    when 1
      Date.new Time.zone.now.to_date.year, Time.zone.now.to_date.month, pieces.first
    when 2
      Date.new Time.zone.now.to_date.year, pieces.first, pieces.last
    when 3
      pieces[2] = pieces[2] + 2000 if pieces[2] < 100
      Date.new pieces[2], pieces[0], pieces[1]
    else
      Time.zone.now.to_date
    end
  rescue
    Time.zone.now.to_date
  end
  
end