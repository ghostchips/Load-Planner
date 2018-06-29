require_relative '../lib'
require 'faraday'
require 'json'
require 'dotenv'

module Carrier
  module RouteBuilder
    
    def build_route(origin, *address_list)
      build_request([origin, *address_list])
      .then { |data| make_request(data) }
      .then { |data| transform_response(data) }
      .then { |data| sort_by_distance(data) }
    end
    
    private
    # \https://maps.googleapis.com/maps/api/distancematrix/json\?origins\=Vancouver+BC\|Seattle\&destinations\=San+Francisco\|Victoria+BC\&key\=
    
    def build_request(addresses)
      origins, destinations, api_key, address_pairs = build_params(addresses)

      { address_list: { origin: addresses.first, all: addresses, pairs: address_pairs }, 
        params: { origins: origins, destinations: destinations, key: api_key } }
    end
    
    def make_request(data={})
      response = Faraday.new.get 'https://maps.googleapis.com/maps/api/distancematrix/json', data[:params]
      
      { address_list: data[:address_list], response: JSON.parse(response.body) }
    end
    
    def transform_response(data={})
      transformed_response = 
        get_rows(data[:response])
        .then { |response| merge_addresses(response, data[:address_list][:pairs]) }
        .then { |response| remove_invalid_combinations(response)}
        
      { address_list: data[:address_list], transformed_response: transformed_response }
    end
    
    def sort_by_distance(data={})
      new_data, leg = next_leg(data[:transformed_response], data[:address_list][:origin])
      (0..data[:address_list][:all].length).reduce([leg]) do |trip, _|
        next_destination = trip.last&.fetch('destination')
        new_data, leg = next_leg(new_data, next_destination)
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
    
    # HELPERS
    
    def build_params(addresses)
      address_pairs = addresses.flat_map do |a2|
        addresses.map { |a3| { 'origin' => a2, 'destination' => a3 } }
      end
      formatted_addresses = addresses.map { |address| address.gsub(', ', '+')  }.join('|')
      [formatted_addresses, formatted_addresses, ENV['MAPS_API'], address_pairs]
    end
    
    def get_rows(response)
      response["rows"].flat_map { |row| row["elements"] }
    end
    
    def merge_addresses(rows, pairs)
      rows.map.with_index { |run, index| pairs[index].merge(run) }
    end
    
    def remove_invalid_combinations(data)
      data.reject { |c| c['origin'] == c['destination']}
    end
    
  end
end
