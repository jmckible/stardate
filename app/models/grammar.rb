class Grammar
  
  def self.parse(string)
    if string =~ /^\d+\/\d+/
      date, string = Grammar.pop_date string
    else
      date = Date.today
    end
    
    if string =~ /^(\$|\+)/
      words = string.split ' '
      explicit_value = words.shift.gsub('$', '')
      string = words.join ' '
      Item.new :date=>date, :explicit_value=>explicit_value, :vendor_name=>string
    else
      Note.new :date=>date, :body=>string
    end
  end
  
  def self.pop_date(string)
    words = string.split ' '
    return Grammar.parse_date(words.shift), words.join(' ')
  end
  
  def self.parse_date(string=nil)
    return Date.today if string.nil?
    pieces = string.split('/').collect(&:to_i)
    case pieces.length
    when 1
      Date.new Date.today.year, Date.today.month, pieces.first
    when 2
      Date.new Date.today.year, pieces.first, pieces.last
    when 3
      pieces[2] = pieces[2] + 2000 if pieces[2] < 100
      Date.new pieces[2], pieces[0], pieces[1]
    else
      Date.today
    end
  rescue
    Date.today
  end
  
end