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
    
    enum NextPageLoadingState: Equatable {
        case loading
        case success
        case failure
        case limitReached
    }
    
    @Published private(set) var businesses: [Business] = []
    @Published private(set) var searchState: SearchState = .empty
    @Published private(set) var nextPageLoadingState: NextPageLoadingState?
    
    private let businessFetchLimit: Int
    private let network: any NetworkProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var businessFetchOffset: Int
    
    init(network: some NetworkProtocol, businessFetchLimit: Int = 20) {
        self.network = network
        self.businessFetchLimit = businessFetchLimit
        self.businessFetchOffset = businessFetchLimit
    }
    
    func evaluateSearchState(searchText: String) {
        Task { @MainActor in
            searchState = .loading
            do {
                businesses = try await network.fetchBusinesses(searchText, limit: 20, offset: 0).businesses
                searchState = .success
                nextPageLoadingState = .success
            } catch let error as NetworkError {
                searchState = .failure(error: error)
            }
        }
    }
    
    @MainActor
    func getNextPage(searchText: String) async {
        guard businessFetchLimit + businessFetchOffset <= 240 else {
            // Yelp API doesn't support limit + offset larger than 240
            nextPageLoadingState = .limitReached
            return
        }
        nextPageLoadingState = .loading
        do {
            print("limit: \(businessFetchLimit), offset: \(businessFetchOffset)")
            let nextPage = try await network.fetchBusinesses(searchText, limit: businessFetchLimit, offset: businessFetchOffset).businesses
            businesses += nextPage
            businessFetchOffset += businessFetchLimit
            nextPageLoadingState = .success
        } catch {
            nextPageLoadingState = .failure
        }
    }
    
    func setEmptySearchState() {
        searchState = .empty
    }
}
