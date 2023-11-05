//
//  InitialMapViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit

public class InitialMapViewModel: ObservableObject {
    public var locations: [MapLocation]
    public var locationNames: [String] {
        locations.map { $0.name }
    }
    
    public init(locations: [MapLocation] = [MapLocation(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
                                         MapLocation(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))]) {
        self.locations = locations
    }
    
    public func addLocation(location: MapLocation) {
        locations.append(location)
    }
    
    public func fetchRestaurants() {
        // TODO: Write API call
    }
}
