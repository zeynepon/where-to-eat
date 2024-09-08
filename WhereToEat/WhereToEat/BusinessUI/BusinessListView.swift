//
//  BusinessListView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessListView: View {
    @StateObject var mapViewModel: MapViewModel
    private let favouritesViewModel: FavouritesViewModel
    
    init(favouritesViewModel: FavouritesViewModel, mapViewModel: MapViewModel) {
        self.favouritesViewModel = favouritesViewModel
        self._mapViewModel = StateObject(wrappedValue: mapViewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if let businesses = mapViewModel.businesses {
                    ForEach(businesses, id: \.self) { business in
                        NavigationLink {
                            BusinessView(business: business, viewModel: BusinessViewModel(business: business, favouritesViewModel: favouritesViewModel))
                        } label: {
                            Text(business.name)
                        }
                    }
                } else if mapViewModel.showErrorScreen {
                    businessListErrorView
                }
            }
            .refreshable { await fetchBusinesses() }
            .searchable(text: $mapViewModel.searchText)
            .navigationTitle("Businesses")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var businessListErrorView: some View {
        VStack(spacing: .zero) {
            Spacer()
            HStack(spacing: .zero) {
                Spacer()
                VStack {
                    Text("We are unable to fetch the data right now. Please try again.")
                        .multilineTextAlignment(.center)
                    Button {
                        Task {
                            await fetchBusinesses()
                        }
                    } label: {
                        Text("Try again")
                            .bold()
                    }
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    private func fetchBusinesses() async {
        do {
            mapViewModel.businesses = try await mapViewModel.fetchData(mapViewModel.searchText).businesses
        } catch {
            mapViewModel.showErrorScreen = true
        }
    }
}
