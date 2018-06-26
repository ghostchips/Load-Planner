require_relative 'lib/lib'

c = Container.new(length: 5, width: 4, height: 6)
b1 = Box.new(length: 2, width: 1, height: 3, receiver_address: 'Ringwood, VIC, Australia')
b2 = Box.new(length: 3, width: 2, height: 1, receiver_address: 'Belgrave, VIC, Australia')
b3 = Box.new(length: 1, width: 3, height: 2, receiver_address: 'Boronia, VIC, Australia')

c.add_box(b1, b2, b3)
c.boxes.sort_by_starting_point('Melbourne, VIC, Australia')