//
//  InitialMapViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit

public class InitialMapViewModel: ObservableObject {
    public var locations: [Location]
    public var locationNames: [String] {
        locations.map { $0.name }
    }
    
    public init(locations: [Location] = [Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
                                         Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))]) {
        self.locations = locations
    }
    
    public func addLocation(location: Location) {
        locations.append(location)
    }
}
