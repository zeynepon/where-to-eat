//
//  InitialMapViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 11/4/23.
//

import MapKit
import SwiftUI
import Combine

@MainActor
public class MapViewModel: ObservableObject {
    @Published public var businesses: [Business]?
    @Published public var searchText: String = ""
    @Published public var showErrorScreen: Bool = false
    
    private let network: any NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(network: some NetworkProtocol) {
        self.network = network
        observeSearchTextUpdates()
    }
    
    func getBusinesses(searchText: String) throws {
        Task { @MainActor in
            businesses = try await network.fetchBusinesses(searchText).businesses
        }
    }
    
    private func observeSearchTextUpdates() {
        $searchText
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] newSearchText in
                guard let self, newSearchText != "" else { return }
                do {
                    try self.getBusinesses(searchText: newSearchText)
                } catch {
                    self.showErrorScreen = true
                }
            }
            .store(in: &cancellables)
    }
}
