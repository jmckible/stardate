class DataPoint
  attr :name
  attr :value
  attr :number
  
  def initialize(name, value, number)
    @name   = name
    @value  = value
    @number = number
  end
  
  def <=>(other)
    value <=> other.value
  end
end