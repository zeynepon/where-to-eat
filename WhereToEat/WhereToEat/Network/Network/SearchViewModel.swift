//
//  SearchViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit
import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    enum SearchState {
        case empty
        case loading
        case success
        case failure(error: NetworkError)
    }
    
    @Published private(set) var businesses: [Business]?
    @Published private(set) var searchState: SearchState = .empty
    
    private let network: any NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(network: some NetworkProtocol) {
        self.network = network
    }
    
    func evaluateSearchState(searchText: String) {
        Task { @MainActor in
            searchState = .loading
            do {
                businesses = try await network.fetchBusinesses(searchText).businesses
                searchState = .success
            } catch let error as NetworkError {
                searchState = .failure(error: error)
            }
        }
    }
    
    func setEmptySearchState() {
        searchState = .empty
    }
}
