//
//  NetworkError.swift
//  WhereToEat
//
//  Created by Zeynep on 25/07/2024.
//

enum NetworkError: Error {
    case invalidServerResponse
    case invalidURL
    case unsupportedJson
}
