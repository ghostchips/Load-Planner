require 'delegate'

class BoxArray < SimpleDelegator
  
  def initialize(*elements)
    super([*elements])
    @connection = Faraday.new(url: 'https://maps.googleapis.com/maps/api/distancematrix/json')
  end
  
  def sort_by_starting_point(address)
    
  end
  
  private
  attr_reader :connection
  
  def make_calls
    connection.get # ...
  end
  
  def group_by_address
    self.group_by { |box| box.receiver_address }
  end
end