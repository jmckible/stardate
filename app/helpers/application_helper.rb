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
