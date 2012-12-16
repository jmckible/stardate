module ApplicationHelper
  
  def vendor_name(thing)
    return '' unless thing.vendor
    link_to thing.vendor.name, thing.vendor, class: 'vendor'
  end
  
  def linked_tag_list(thing)
    thing.tags.collect{|t|link_to t.name, tag_path(t)}.join(', ').html_safe
  end
  
  def color_money(value)
    return '0' if value.nil?
    if value < 0
      content_tag :span, number_with_delimiter(value*-1), class: 'negative'
    elsif value > 0
      content_tag :span, number_with_delimiter(value), class: 'positive' 
    else
       '0'
    end
  end
  
  def color_explicit_money(value)
    return '0' if value.nil?
    if value < 0
      content_tag :span, number_with_delimiter(value), class: 'negative'
    elsif value > 0
      content_tag :span, number_with_delimiter(value), class: 'positive'
    else
       '0'
    end
  end
  
  def minutes_to_time(minutes)
    if minutes <= 60
      "#{minutes} min"
    else
      "#{minutes.div 60}hr #{minutes.modulo 60}min"
    end
  end
  
  def humanize_period(period)
    if period.first.day == 1 and period.last == Date.civil(period.first.year, period.first.month, -1)
      period.first.strftime('%B, %Y')
    elsif period.first.year == period.last.year and period.first.month == period.last.month
      period.first.strftime('%B %e') + ' - ' + period.last.strftime('%e, %Y')
    elsif period.first.year == period.last.year
      period.first.strftime('%B %e') + ' - ' + period.last.strftime('%B %e, %Y')
    else
      period.first.strftime('%B %e, %Y') + ' - ' +  period.last.strftime('%B %e, %Y')
    end
  end
  
  def minutes_to_clock(minutes)
    hours, minutes = minutes.to_i.divmod(60)
    minutes = "0#{minutes}" if minutes < 10
    [hours, minutes].join(':')
  end
  
  def date_link(date)
    date_path(year: date.year, month: date.month, day: date.day)
  end
  
  def budget_link(budget, period)
    link_to color_money(budget.difference_during(period)), 
      budget_path(budget, start: {year: period.first.year, month: period.first.month, day: period.first.day}, 
        finish: {year: period.last.year, month: period.last.month, day: period.last.day})
  end

  def not_zero(number)
    number_with_delimiter(number) unless number.zero?
  end

end
