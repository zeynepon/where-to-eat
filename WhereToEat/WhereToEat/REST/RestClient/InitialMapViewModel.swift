//
//  InitialMapViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit
import SwiftUI

public class InitialMapViewModel: NSObject, ObservableObject, RestClientProtocol {
    public typealias FetchedData = Businesses
    
    // TODO: ID where you've used design patterns
    private enum NetworkError: Error {
        case invalidServerResponse
        case unsupportedJson
    }
    
    weak var coordinator: RestaurantsCoordinator?
    
    public var locations: [MapLocation]
    public var locationNames: [String] {
        locations.map { $0.name }
    }
    @Published public private(set) var region: MKCoordinateRegion?
    @Published public private(set) var showUserLocation: Bool = false
    
    init(coordinator: RestaurantsCoordinator? = nil, locations: [MapLocation] = []) {
        self.region = nil
        self.coordinator = coordinator
        self.locations = locations
        
        super.init()
    }
    
    public func addLocation(location: MapLocation) {
        locations.append(location)
    }
    
    public func fetchData(_ input: String) async throws -> Businesses? {
        // TODO: Fix warnings that have showed up in the console
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=food&location=\(input)") else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer pVVq8q3TDb1qdoYtd7YUHKs2olodh9JhoFVylUw17EdPOA7e5gYziWnIiZ5fuTTUZJWqGJ6s7XstTsfwyHubZi3-jzhqjO1X0CuXMhhPdckzTVchO-N6osSQI7VHZXYx", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        
        guard let businesses = try JSONDecoder().decode(Businesses?.self, from: data) else {
            throw NetworkError.unsupportedJson
        }
        
        return businesses
    }
}
