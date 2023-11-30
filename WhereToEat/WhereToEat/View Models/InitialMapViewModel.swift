//
//  InitialMapViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit

public class InitialMapViewModel: ObservableObject {
    // TODO: Refactor folders
    // TODO: ID where you've used design patterns
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
    
    public func fetchRestaurants(searchText: String) async throws -> Businesses? {
        // TODO: Fix warnings that have showed up in the console
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=food&location=\(searchText)") else { return nil }
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
        Business(name: "Borough Market",
                 image_url: "https://s3-media1.fl.yelpcdn.com/bphoto/r_vCRy6Cc3i425lsoawvrA/o.jpg",
                 is_closed: false,
                 url: "https://www.yelp.com/biz/borough-market-london-3?adjust_creative=RcwV6drVskI_uxj8EFdA6Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=RcwV6drVskI_uxj8EFdA6Q",
                 review_count: 1843,
                 categories: [Category(title: "Farmers Market"), Category(title: "Beer, Wine & Spirits")],
                 rating: 4.5,
                 coordinates: Coordinate(latitude : 51.5051427191678, longitude : -0.0909365332063361),
                 price: "££",
                 location: Location(address1: "8 Southwark Street",
                                    city: "London",
                                    zip_code: "SE1 1TL",
                                    country: "GB",
                                    display_address: ["8 Southwark Street", "London SE1 1TL", "United Kingdom"]),
                 phone: "+442030262283",
                 display_phone: "+44 20 3026 2283",
                 distance: 3230.9293288880117)
    }
}
