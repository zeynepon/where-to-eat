//
//  SearchViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit
import SwiftUI
import Combine

public class SearchViewModel: ObservableObject {
    public enum SearchState {
        case empty
        case loading
        case success
        case failure
    }
    
    @Published public private(set) var businesses: [Business]?
    @Published public private(set) var searchState: SearchState = .empty
    
    private let network: any NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(network: some NetworkProtocol) {
        self.network = network
    }
    
    func getBusinesses(searchText: String) throws {
        Task { @MainActor in
            businesses = try await network.fetchBusinesses(searchText).businesses
        }
    }
    
    func evaluateSearchState(searchText: String) {
        Task { @MainActor in
            searchState = .loading
            do {
                let businesses = try await network.fetchBusinesses(searchText).businesses
                self.businesses = businesses
                searchState = .success
            } catch {
                searchState = .failure
            }
        }
    }
    
    func setEmptySearchState() {
        searchState = .empty
    }
}
