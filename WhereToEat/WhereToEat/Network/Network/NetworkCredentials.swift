//
//  NetworkCredentials.swift
//  WhereToEat
//
//  Created by Zeynep on 08/09/2024.
//

protocol NetworkCredentialsProtocol {
    var apiKey: String { get }
}

class NetworkCredentials: NetworkCredentialsProtocol {
    var apiKey: String {
        "pVVq8q3TDb1qdoYtd7YUHKs2olodh9JhoFVylUw17EdPOA7e5gYziWnIiZ5fuTTUZJWqGJ6s7XstTsfwyHubZi3-jzhqjO1X0CuXMhhPdckzTVchO-N6osSQI7VHZXYx"
    }
}
