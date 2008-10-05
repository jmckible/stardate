# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def color_value(value)
    return '&nbsp;' if value.nil?
    if value < 0
      content_tag :span, number_with_delimiter(value*-1), :class=>'red'
    elsif value > 0
      content_tag :span, number_with_delimiter(value), :class=>'green'
    else
       '&nbsp;'
    end
  end
  
  def color_money(value)
    return '0' if value.nil?
    if value < 0
      content_tag :span, number_with_delimiter(value*-1), :class=>'red'
    elsif value > 0
      content_tag :span, number_with_delimiter(value), :class=>'green'
    else
       '0'
    end
  end

  def items_for_calendar(date=Date.today)
    str  = content_tag :span, date.mday, :class=>"date" 
    str += "<dl>"
    for item in current_user.items.on(date)
      str += content_tag :dt, link_to(item.value, edit_item_path(item))
      str += content_tag :dd, h(item.calendar_description)
    end
    str += "</dl>"
  end
  
  def recurring_for_calendar(date=Date.today)
    str  = content_tag :span, date.mday, :class=>"date" 
    str += "<dl>"
    for recurring in current_user.recurrings.on(date)
      str += content_tag :dt, link_to(recurring.explicit_value, edit_recurring_path(recurring))
      str += content_tag :dd, h(recurring.inline_description)
    end
    str += "</dl>"
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
  
  def footer
    "ActiveBudget is available under the #{link_to 'MIT license', 'http://www.opensource.org/licenses/mit-license.php'} and managed by #{link_to 'Jordan McKible', 'http://jordan.mckible.com'}"
  end
end
