require_relative 'lib/lib'

c = Carrier::Container.new(length: 5, width: 4, height: 6, capacity: 200)
b1 = Carrier::Package.new(length: 2, width: 1, height: 9, weight: 4, destination: 'Ringwood, VIC, Australia')
b2 = Carrier::Package.new(length: 3, width: 2, height: 3, weight: 2, destination: 'Belgrave, VIC, Australia')
b3 = Carrier::Package.new(length: 1, width: 3, height: 3, weight: 12, destination: 'Boronia, VIC, Australia')
b4 = Carrier::Package.new(length: 2, width: 1, height: 1, weight: 10, destination: 'Ringwood, VIC, Australia')
b5 = Carrier::Package.new(length: 3, width: 2, height: 4, weight: 10, destination: 'Belgrave, VIC, Australia')
b6 = Carrier::Package.new(length: 1, width: 3, height: 1, weight: 10, destination: 'Belgrave, VIC, Australia')

c.add_package(b1, b2, b3, b4, b5, b6)
c.sort_by_origin('Melbourne, VIC, Australia').each {|s| p s}
puts ''
c.content.each {|s| p s}
