# frozen_string_literal: true
require_relative 'lib/lib'

c = Carrier::Container.new(length: 5, width: 4, height: 6, capacity: 200)
p1 = Carrier::Package.new(length: 2, width: 1, height: 9, weight: 4, destination: 'Ringwood, VIC, Australia')
p2 = Carrier::Package.new(length: 3, width: 2, height: 3, weight: 2, destination: 'Belgrave, VIC, Australia')
p3 = Carrier::Package.new(length: 1, width: 3, height: 3, weight: 12, destination: 'Boronia, VIC, Australia')
p4 = Carrier::Package.new(length: 2, width: 1, height: 1, weight: 10, destination: 'Ringwood, VIC, Australia')
p5 = Carrier::Package.new(length: 3, width: 2, height: 4, weight: 10, destination: 'Belgrave, VIC, Australia')
p6 = Carrier::Package.new(length: 1, width: 3, height: 1, weight: 10, destination: 'Belgrave, VIC, Australia')

c.add_packages(p1, p2, p3, p4, p5, p6)
c.sort_by_origin('Melbourne, VIC, Australia').each {|s| p s}
puts ''
c.content.each {|s| p s}
