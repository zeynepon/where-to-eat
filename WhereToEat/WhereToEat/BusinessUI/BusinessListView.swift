//
//  BusinessListView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessListView: View {
    @StateObject var searchViewModel: SearchViewModel
    @State private var searchText: String = ""
    @State private var isKeyboardShown: Bool = false
    private let favouritesViewModel: FavouritesViewModel
    
    init(favouritesViewModel: FavouritesViewModel, searchViewModel: SearchViewModel) {
        self.favouritesViewModel = favouritesViewModel
        self._searchViewModel = StateObject(wrappedValue: searchViewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                searchBar
                    .padding(.trailing, isKeyboardShown ? nil : 0)
                Spacer()
                switch searchViewModel.searchState {
                case .empty:
                    emptyStateView
                case .loading:
                    progressView
                case .success:
                    businessListView
                case .failure:
                    businessListErrorView
                }
                Spacer()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: searchText) { oldValue, newValue in
            if searchText == "" {
                searchViewModel.setEmptySearchState()
            }
        }
        .onReceive(keyboardPublisher) { newValue in
            isKeyboardShown = newValue
        }
    }
    
    @ViewBuilder
    private var businessListView: some View {
        List {
            if let businesses = searchViewModel.businesses {
                ForEach(businesses, id: \.self) { business in
                    NavigationLink {
                        BusinessView(business: business, viewModel: BusinessViewModel(business: business, favouritesViewModel: favouritesViewModel))
                    } label: {
                        Text(business.name)
                    }
                }
            }
        }
        .padding(.top, -16)
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
                        searchViewModel.evaluateSearchState(searchText: searchText)
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
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 4) {
            Text("Start your search for restaurants here 🔎")
                .font(.title)
                .bold()
            Text("Enter a location in which you'd like to see restaurants")
                .font(.headline)
        }
        .multilineTextAlignment(.center)
        .fontDesign(.serif)
    }
    
    private var progressView: some View {
        VStack(spacing: 8) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading restaurants...")
        }
    }
    
    private var searchBar: some View {
        HStack {
            SearchViewRepresentable(searchText: $searchText, viewModel: searchViewModel)
            if isKeyboardShown {
                Button("Cancel") {
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
}
