//
//  NetworkProtocol.swift
//  WhereToEat
//
//  Created by Zeynep on 12/1/23.
//

import Foundation

protocol NetworkProtocol {
    var networkCredentials: NetworkCredentialsProtocol { get }
    var session: URLSession { get }
    
    func fetchBusinesses(_ searchText: String) async throws -> Businesses
    func fetchBusinessDetails(businessAlias: String) async throws -> BusinessDetails
}

class Network: NetworkProtocol {
    let networkCredentials: any NetworkCredentialsProtocol
    let session = URLSession.shared
    
    init(networkCredentials: some NetworkCredentialsProtocol = NetworkCredentials()) {
        self.networkCredentials = networkCredentials
    }
    
    public func fetchBusinesses(_ searchText: String) async throws -> Businesses {
        guard let url = URL(string: "\(networkCredentials.baseURL)search?term=food&location=\(searchText)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        networkCredentials.setRequestValues(for: &request)
        
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw httpResponse.statusCode == 400 ? NetworkError.locationNotFound : NetworkError.invalidServerResponse
        }
        
        guard let businesses = try JSONDecoder().decode(Businesses?.self, from: data) else {
            throw NetworkError.unsupportedJson
        }
        
        return businesses
    }
    
    func fetchBusinessDetails(businessAlias: String) async throws -> BusinessDetails {
        guard let url = URL(string: "\(networkCredentials.baseURL)\(businessAlias)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        networkCredentials.setRequestValues(for: &request)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw httpResponse.statusCode == 400 ? NetworkError.locationNotFound : NetworkError.invalidServerResponse
        }
        
        guard let businessDetails = try JSONDecoder().decode(BusinessDetails?.self, from: data) else {
            throw NetworkError.unsupportedJson
        }
        
        return businessDetails
    }
}
