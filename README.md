This is a small test study to scope out the new Google maps platform API to calculate load planning for trucks making deliveries.

Given a point of origin and each package having a destination, the idea is to determine the package loading order by calculating the shortest route between each destination, starting from the point of origin. The packages are then are arranged in reverse order, with the last deliveries going in first and the first deliveries going in last.

```ruby
# New carrying container
truck_container = Carrier::Container.new(
  length: 5, width: 4, height: 6, capacity: 200)

# Packages with various dimensions and destinations
package1 = Carrier::Package.new(
  length: 2, width: 1, height: 9, weight: 4,
  destination: 'Ringwood, VIC, Australia')
package2 = Carrier::Package.new(
  length: 3, width: 2, height: 3, weight: 2,
  destination: 'Belgrave, VIC, Australia')
package3 = Carrier::Package.new(
  length: 1, width: 3, height: 3, weight: 12,
  destination: 'Boronia, VIC, Australia')
package4 = Carrier::Package.new(
  length: 2, width: 1, height: 1, weight: 10,
  destination: 'Ringwood, VIC, Australia')
package5 = Carrier::Package.new(
  length: 3, width: 2, height: 4, weight: 10,
  destination: 'Belgrave, VIC, Australia')
package6 = Carrier::Package.new(
  length: 1, width: 3, height: 1, weight: 10,
  destination: 'Belgrave, VIC, Australia')


truck_container.add_packages(
  package1, package2, package3, package4, package5, package6)

truck_container.sort_by_origin('Melbourne, VIC, Australia') 
```
The above returns an array of packages in the correct loading order. If there are packages with the same destination, as in above, then these are sorted by weight and volume, heavier and larger packages going in first.

TODO:

- Allow for full addressing and/or coordinates to be used as destinations.
- Consider origin as final destination when determining delivery route.
- Calculate package placement based on package/truck dimensions/capacity.
- Fine tune package and container packages to real values (cm, kg, etc)
