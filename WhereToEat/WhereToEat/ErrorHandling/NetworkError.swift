//
//  NetworkError.swift
//  WhereToEat
//
//  Created by Zeynep on 25/07/2024.
//

enum NetworkError: Error {
    case businessUnavailable
    case invalidServerResponse
    case invalidURL
    case locationNotFound
    case unsupportedJson
    
    var description: String {
        switch self {
        case .businessUnavailable:
            "No images"
        case .invalidServerResponse, .invalidURL:
            "We are unable to connect to the server right now. Please try again."
        case .locationNotFound:
            "Could not execute search, try specifying a more exact location."
        case .unsupportedJson:
            "We are unable to fetch the data right now. Please try again."
        }
    }
}
