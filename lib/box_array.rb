require 'delegate'
require 'faraday'
require 'json'

class BoxArray < SimpleDelegator
  
  def initialize(*elements)
    super([*elements])
    @connection = Faraday.new #(url: 'https://maps.googleapis.com/maps/api/distancematrix/json')
  end
  
  def sort_by_starting_point(address)
    build_request(address)
    .yield_self { |params| make_request(params) }
    .yield_self { |response| transform_response(response) }
    .yield_self { |data| sort_by_distance(data) }
  end
  
  # private
  attr_reader :connection, :address_pairs, :params, :response, :sender_address, :addresses
  # \https://maps.googleapis.com/maps/api/distancematrix/json\?origins\=Vancouver+BC\|Seattle\&destinations\=San+Francisco\|Victoria+BC\&key\=
  
  def build_request(address)
    @sender_address = address
    origins, destinations = build_addresses(@addresses = [address, *group_by_address.keys])
    { origins: origins, destinations: destinations, key: ENV['MAPS_API'] }    
  end
  
  def make_request(params)
    response = connection.get 'https://maps.googleapis.com/maps/api/distancematrix/json', params
    JSON.parse(response.body)
  end
  
  def transform_response(response)
    get_rows(response)
    .yield_self { |rows| merge_addresses(rows) }
    .yield_self { |data| remove_invalid_combinations(data)}
  end
  
  def get_rows(response)
    response["rows"].flat_map do |row|
      row["elements"].map(&:itself)
    end    
  end
  
  def merge_addresses(rows)
    rows.map.with_index do |run ,index|
      address_pairs[index].merge(run)
    end
  end
  
  def remove_invalid_combinations(data)
    data.reject { |c| c['origin'] == c['destination']}
  end
  
  def build_addresses(addresses)
    @address_pairs = addresses.flat_map do |a2|
      addresses.map { |a3| { 'origin' => a2, 'destination' => a3 } }
    end
    addresse_list = addresses.map { |address| address.gsub(', ', '+')  }.join('|')
    [addresse_list, addresse_list]
  end
  
  def sort_by_distance(data)
    data, leg = next_leg(data, sender_address)
    addresses.each.with_index.reduce([leg]) do |trip, (_, index)|
      if trip[index]
        data, leg = next_leg(data, trip[index]['destination'])
        trip << leg
      else
        trip
      end
    end
  end
  
  def next_leg(data, address)
    address_legs, new_data = data.partition { |a| a['origin'] == address || a['destination'] == address }
    next_leg = address_legs.select { |a| a['origin'] == address }.min_by do |leg|
      [leg['duration']['value'], leg['distance']['value']]
    end
    [new_data, next_leg]
  end
  
  def group_by_address
    self.group_by { |box| box.receiver_address }
  end
end