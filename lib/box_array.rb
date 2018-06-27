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
    # .yield_self { |runs| sort_boxes_by(runs) }
  end

  # private
  attr_reader :connection, :address_pairs, :sender_address, :addresses
  # \https://maps.googleapis.com/maps/api/distancematrix/json\?origins\=Vancouver+BC\|Seattle\&destinations\=San+Francisco\|Victoria+BC\&key\=

  def build_request(address)
    @sender_address = address
    origins, destinations = build_addresses(@addresses = [address, *group_by_address.keys])
    { origins: origins, destinations: destinations, key: ENV['MAPS_API'] }
  end

  def build_addresses(addresses)
    @address_pairs = addresses.flat_map do |a2|
      addresses.map { |a3| { 'origin' => a2, 'destination' => a3 } }
    end
    addresse_list = addresses.map { |address| address.gsub(', ', '+')  }.join('|')
    [addresse_list, addresse_list]
  end

  def make_request(params)
    response = @connection.get 'https://maps.googleapis.com/maps/api/distancematrix/json', params
    JSON.parse(response.body)
  end

  def transform_response(response)
    get_rows(response)
    .yield_self { |rows| merge_addresses(rows) }
    .yield_self { |data| remove_invalid_combinations(data)}
  end

  def get_rows(response)
    response["rows"].flat_map { |row| row["elements"] }
  end

  def merge_addresses(rows)
    rows.map.with_index { |run, index| @address_pairs[index].merge(run) }
  end

  def remove_invalid_combinations(data)
    data.reject { |c| c['origin'] == c['destination']}
  end

  def sort_by_distance(data)
    data, leg = next_leg(data, @sender_address)
    (0..@addresses.length).reduce([leg]) do |trip, _|
      next_destination = trip.last&.fetch('destination')
      data, leg = next_leg(data, next_destination)
      leg ? trip << leg : trip
    end
  end

  def next_leg(data, address)
    return unless address
    address_legs, new_data = data.partition do |a|
      a['origin'] == address || a['destination'] == address
    end
    next_leg = address_legs.select { |a| a['origin'] == address }.min_by do |leg|
      [leg['duration']['value'], leg['distance']['value']]
    end
    [new_data, next_leg]
  end

  def sort_boxes_by(runs)
    # ...
  end

  def group_by_address
    self.group_by { |box| box.receiver_address }
  end
end