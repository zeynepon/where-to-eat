//
//  InitialMapViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit

public class InitialMapViewModel: ObservableObject {
    private enum NetworkError: Error {
        case invalidServerResponse
        case unsupportedJson
    }
    
    public var locations: [MapLocation]
    public var locationNames: [String] {
        locations.map { $0.name }
    }
    
    public init(locations: [MapLocation] = []) {
        self.locations = locations
    }
    
    public func addLocation(location: MapLocation) {
        locations.append(location)
    }
    
    public func fetchRestaurants() async throws -> Businesses? {
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=food&location=London") else { return nil }
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

public extension InitialMapViewModel {
    func createMockBusiness() -> Business {
        Business(name: "Mock Business",
                 image_url: "",
                 is_closed: false,
                 url: "",
                 review_count: 20,
                 categories: [Category(title: "Food")],
                 rating: 4.6,
                 coordinates: Coordinate(latitude: 0, longitude: 0),
                 location: Location(address1: "Address",
                                    city: "London",
                                    zip_code: "NW1 AA1",
                                    country: "United Kingdom",
                                    display_address: ["London"]),
                 phone: "",
                 display_phone: "",
                 distance: 1)
    }
}
