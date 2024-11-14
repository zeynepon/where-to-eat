//
//  NetworkProtocol.swift
//  WhereToEat
//
//  Created by Zeynep on 12/1/23.
//

import Foundation

public protocol NetworkProtocol {
    func fetchBusinesses(_ searchText: String) async throws -> Businesses
}

class Network: NetworkProtocol {
    private let networkCredentials = NetworkCredentials()
    
    public func fetchBusinesses(_ searchText: String) async throws -> Businesses {
        // TODO: Fix warnings that have showed up in the console
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=food&location=\(searchText)") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(networkCredentials.apiKey)", forHTTPHeaderField: "Authorization")
        
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
