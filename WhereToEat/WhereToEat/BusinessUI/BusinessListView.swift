//
//  BusinessListView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessListView: View {
    @StateObject var searchViewModel: SearchViewModel
    private let favouritesViewModel: FavouritesViewModel
    
    init(favouritesViewModel: FavouritesViewModel, searchViewModel: SearchViewModel) {
        self.favouritesViewModel = favouritesViewModel
        self._searchViewModel = StateObject(wrappedValue: searchViewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if let businesses = searchViewModel.businesses {
                    ForEach(businesses, id: \.self) { business in
                        NavigationLink {
                            BusinessView(business: business, viewModel: BusinessViewModel(business: business, favouritesViewModel: favouritesViewModel))
                        } label: {
                            Text(business.name)
                        }
                    }
                } else if searchViewModel.showErrorScreen {
                    businessListErrorView
                }
            }
            .refreshable { fetchBusinesses() }
            .searchable(text: $searchViewModel.searchText)
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
                        fetchBusinesses()
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
    
    private func fetchBusinesses() {
        do {
            try searchViewModel.getBusinesses(searchText: searchViewModel.searchText)
        } catch {
            searchViewModel.showErrorScreen = true
        }
    }
}
