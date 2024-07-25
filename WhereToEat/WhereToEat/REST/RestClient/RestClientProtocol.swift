//
//  RestClientProtocol.swift
//  WhereToEat
//
//  Created by Zeynep on 12/1/23.
//

public protocol RestClientProtocol {
    associatedtype FetchedData: DataTypeProtocol
    func fetchData(_ input: String) async throws -> FetchedData
}
