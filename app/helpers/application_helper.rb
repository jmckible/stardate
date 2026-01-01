module ApplicationHelper

  def color_money(value)
    return '0' if value.nil?
    if value.negative?
      content_tag :span, number_with_delimiter(value*-1), class: 'negative'
    elsif value.positive?
      content_tag :span, number_with_delimiter(value), class: 'positive'
    else
      '0'
    end
  end

  def date_link(date)
    date_path year: date.year, month: date.month, day: date.day
  end

  def humanize_period(period)
    if period.first.day == 1 && period.last == Date.civil(period.first.year, period.first.month, -1)
      period.first.strftime('%B, %Y')
    elsif period.first.year == period.last.year && period.first.month == period.last.month
      period.first.strftime('%B %e') + ' - ' + period.last.strftime('%e, %Y')
    elsif period.first.year == period.last.year
      period.first.strftime('%B %e') + ' - ' + period.last.strftime('%B %e, %Y')
    else
      period.first.strftime('%B %e, %Y') + ' - ' +  period.last.strftime('%B %e, %Y')
    end
  end

  def linked_tag_list(thing)
    thing.tags.collect{|t| link_to t.name, tag_path(t)}.join(', ').html_safe
  end

  def minutes_to_time(minutes)
    if minutes <= 60
      "#{minutes} min"
    else
      "#{minutes.div 60}hr #{minutes.modulo 60}min"
    end
  end

  def modal(&block)
    turbo_frame_tag 'modal' do
      content_tag :div, class: 'modal-background', data: { controller: 'modal', action: 'mousedown->modal#handleMouseDown click->modal#close'} do
        content_tag :div, class: 'modal-body' do
          yield block
        end
      end
    end
  end

  def not_zero(number)
    number_with_delimiter(number) unless number.zero?
  end

  def vendor_name(thing)
    return '' unless thing.vendor
    link_to thing.vendor.name, thing.vendor, class: 'vendor'
  end

end
