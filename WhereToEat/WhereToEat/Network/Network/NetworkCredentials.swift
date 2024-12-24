//
//  NetworkCredentials.swift
//  WhereToEat
//
//  Created by Zeynep on 08/09/2024.
//

import Foundation

protocol NetworkCredentialsProtocol {
    var baseURL: String { get }
    var apiKey: String { get }
    
    func setRequestValues(for request: inout URLRequest)
}

class NetworkCredentials: NetworkCredentialsProtocol {
    let baseURL: String = "https://api.yelp.com/v3/businesses/"
    
    var apiKey: String {
        "pVVq8q3TDb1qdoYtd7YUHKs2olodh9JhoFVylUw17EdPOA7e5gYziWnIiZ5fuTTUZJWqGJ6s7XstTsfwyHubZi3-jzhqjO1X0CuXMhhPdckzTVchO-N6osSQI7VHZXYx"
    }
    
    func setRequestValues(for request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    }
}
