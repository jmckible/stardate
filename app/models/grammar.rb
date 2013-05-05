class Grammar
  
  def self.parse(string, household)
    date     = Grammar.parse_date string.slice!(/\A\d+\/\d+(\/\d+)?\s/)
    tag_list = (string.slice!(/\s\[.+\]\z/) || '').gsub(/(\A\s\[)|(\]\z)/, '')

    if string =~ /\A(\\z|\+)/
      words = string.split ' '
      amount = words.shift.gsub('\z', '')
      amount = '-' + amount unless amount =~ /\A(\+|-)/
      amount = amount.to_f.round

      string = words.join ' '
      if string =~ /-/
        words  = string.split ' - '
        vendor = words.shift
        description = words.join ' - '
      else
        vendor = string
      end
      transaction = household.transactions.build vendor_name: vendor, description: description, tag_list: tag_list, date: date

      if amount >= 0
        income = household.accounts.income.where(name: vendor).first
        if income
          credit = income
        else
          credit = household.general_income
        end

        transaction.debit = household.cash
        transaction.credit = credit

      else
        key_tag = transaction.tags.detect{|t| household.accounts.expense.tagged_with t}
        if key_tag
          expense = household.accounts.expense.tagged_with(key_tag).first
        else
          expense = household.slush
        end

        if expense && expense.deferral
          source = expense.deferral
        else
          source = household.cash
        end

        transaction.credit = source
        transaction.debit  = expense

        amount = amount * -1 if amount < 0
      end
      
      transaction.amount = amount

      transaction
               
    elsif string =~ /\A(Bike|bike|b )/
      distance, minutes = string.split(/\A(Bike|bike|b) /).last.split(' ')
      Workout.new bike: true, date: date, distance: distance, minutes: minutes
    elsif string =~ /\A(Elliptical|elliptical|e )/
      distance, minutes = string.split(/\A(Elliptical|elliptical|e) /).last.split(' ')
      Workout.new elliptical:true, date: date, distance: distance, minutes: minutes
    elsif string =~ /\A(Nike|nike|n )/
      minutes = string.split(/\A(Nike|nike|n )/).last.split(' ').first
      description = string.split(/\A(Nike|nike|n )/).last.split(' ')[1..-1].join(' ')
      Workout.new nike: true, date: date, minutes: minutes, description: description
    elsif string =~ /\A(P90x|p90x|P90X|p )/
      minutes = string.split(/\A(P90x|p90x|P90X|p90X|p )/).last.split(' ').first
      description = string.split(/\A(P90x|p90x|P90X|p90X|p )/).last.split(' ')[1..-1].join(' ')
      Workout.new p90x: true, date: date, minutes: minutes, description: description
    elsif string =~ /\A(Ran|ran|r )/
      distance, minutes = string.split(/\A(Ran|ran|r) /).last.split(' ')
      Workout.new run: true, date: date, distance: distance, minutes: minutes
    elsif string =~ /\A(Walk|walk)/
      distance, minutes = string.split(/\A(Walk|walk) /).last.split(' ')
      Workout.new walk: true, date: date, distance: distance, minutes: minutes
    elsif string =~ /\A(weight|w )/
      weight = string.split(/\A(weight |w )/).last
      Weight.new date: date, weight: weight
    else
      Note.new date: date, body: string
    end
  #rescue
    #Note.new date: Time.zone.now.to_date, body: 'Failed to parse'
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