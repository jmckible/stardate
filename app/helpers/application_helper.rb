# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def vendor_name(thing)
    return '&nbsp;' unless thing.vendor
    link_to h(thing.vendor.name), thing.vendor
  end
  
  def linked_tag_list(thing)
    thing.tags.collect{|tag| link_to h(tag.name), tag}.join(', ')
  end
  
  def color_money(value)
    return '0' if value.nil?
    if value < 0
      content_tag :span, number_with_delimiter(value*-1), :class=>'negative'
    elsif value > 0
      content_tag :span, number_with_delimiter(value), :class=>'positive'
    else
       '0'
    end
  end
  
  def color_explicit_money(value)
    return '0' if value.nil?
    if value < 0
      content_tag :span, value, :class=>'negative'
    elsif value > 0
      content_tag :span, value, :class=>'positive'
    else
       '0'
    end
  end
  
  def minutes_to_time(minutes)
    if minutes < 60
      "#{minutes}min"
    else
      "#{minutes.div 60}:#{minutes.modulo 60}hr"
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

end
