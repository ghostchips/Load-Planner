# frozen_string_literal: true
require_relative '../lib'
require 'faraday'
require 'json'
require 'dotenv'

module Carrier
  module RouteBuilder

    def build_route(origin, *address_list)
      addresses, pairs = build_addresses([origin, *address_list])
      addresses
      .then { |addrs| build_request(addrs)}
      .then { |params| make_request(params) }
      .then { |response| transform_response(response, pairs) }
      .then { |data| sort_by_distance(data, origin, addresses) }
    end

    private
    # \https://maps.googleapis.com/maps/api/distancematrix/json\?origins\=Vancouver+BC\|Seattle\&destinations\=San+Francisco\|Victoria+BC\&key\=

    def build_addresses(addresses)
      pairs = addresses.flat_map do |a2|
        addresses.map { |a3| { 'origin' => a2, 'destination' => a3 } }
      end
      [addresses, pairs]
    end

    def build_request(addresses)
      formatted_addresses = addresses.map { |address| address.gsub(', ', '+')  }.join('|')

      { origins: formatted_addresses, destinations: formatted_addresses, key: ENV['MAPS_API'] }
    end

    def make_request(params)
      response = Faraday.new.get 'https://maps.googleapis.com/maps/api/distancematrix/json', params
      JSON.parse(response.body)
    end

    def transform_response(response, pairs)
      get_rows(response)
      .then { |resp| merge_addresses(resp, pairs) }
      .then { |addr| remove_invalid_combinations(addr)}
    end

    def sort_by_distance(data, origin, addresses)
      new_data, leg = next_leg(data, origin)
      (0..addresses.length).reduce([leg]) do |trip, _|
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
