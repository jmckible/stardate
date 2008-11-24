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
      Item.new :date=>date, :explicit_value=>explicit_value, :vendor_name=>vendor, 
               :description=>description, :tag_list=>tag_list
    
    elsif string =~ /^(Ran|ran)/
      Run.new :date=>date, :distance=>string.split(/^(Ran|ran) /).last.to_f
    else
      Note.new :date=>date, :body=>string
    end
  rescue
    Note.new :date=>Date.today, :body=>'Failed to parse'
  end
  
  def self.parse_date(string=nil)
    return Date.today if string.nil?
    pieces = string.strip.split('/').collect(&:to_i)
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