//
//  Location.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit

public struct Location {
    let id = UUID()
    public private(set) var name: String
    public private(set) var coordinate: CLLocationCoordinate2D
    
    public init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}
