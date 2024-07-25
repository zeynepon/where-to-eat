//
//  InitialMapViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit
import SwiftUI
import Combine

@MainActor
public class InitialMapViewModel: NSObject, ObservableObject, RestClientProtocol {
    public typealias FetchedData = Businesses
    
    // TODO: ID where you've used design patterns
        
    weak var coordinator: RestaurantsCoordinator?
    
    public var locations: [MapLocation]
    public var locationNames: [String] {
        locations.map { $0.name }
    }
    
    @Published public var businesses: [Business]?
    @Published public var searchText: String = ""
    @Published public var showErrorScreen: Bool = false
    @Published public private(set) var region: MKCoordinateRegion?
    @Published public private(set) var showUserLocation: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: RestaurantsCoordinator? = nil, locations: [MapLocation] = []) {
        self.region = nil
        self.coordinator = coordinator
        self.locations = locations
        
        super.init()
        observeSearchTextUpdates()
    }
    
    public func addLocation(location: MapLocation) {
        locations.append(location)
    }
    
    public func fetchData(_ input: String) async throws -> Businesses {
        // TODO: Fix warnings that have showed up in the console
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=food&location=\(input)") else {
            throw NetworkError.invalidURL
        }
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
    
    private func observeSearchTextUpdates() {
        $searchText
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] newSearchText in
                guard let self, newSearchText != "" else { return }
                do {
                    self.businesses = try await self.fetchData(newSearchText).businesses
                } catch(let error) {
                    self.showErrorScreen = true
                }
            }
            .store(in: &cancellables)
    }
}
