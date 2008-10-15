module ExplicitValue
  # If the value is positive, put a + in front
  def explicit_value
    return if value.nil?
    "#{'+' if value > 0}#{value}"
  end
  
  # Overwriting the default value=
  # Assume input without an explicit - or + preceeding is negative
  def explicit_value=(new_value)
    new_value = new_value.to_s
    return if new_value.blank?
    new_value = '-' + new_value unless new_value =~ /^(\+|-)/
    write_attribute :value, new_value.to_f.round
  end
end