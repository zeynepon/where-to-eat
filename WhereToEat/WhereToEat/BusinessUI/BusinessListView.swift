//
//  BusinessListView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessListView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @State private var searchText: String = ""
    @State private var isKeyboardShown: Bool = false
    private let favoritesViewModel: FavoritesViewModel
    
    init(favoritesViewModel: FavoritesViewModel, searchViewModel: SearchViewModel) {
        self.favoritesViewModel = favoritesViewModel
        self.searchViewModel = searchViewModel
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
                case .failure(let error):
                    businessListErrorView(error: error)
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
            ForEach(searchViewModel.businesses, id: \.self) { business in
                NavigationLink {
                    BusinessView(business: business, viewModel: BusinessViewModel(business: business, favoritesViewModel: favoritesViewModel))
                } label: {
                    Text(business.name)
                }
            }
            if searchViewModel.nextPageLoadingState != .limitReached {
                switch searchViewModel.nextPageLoadingState {
                case .loading:
                    ProgressView("Loading")
                case .success:
                    ProgressView("Loading")
                        .onAppear {
                            Task {
                                await searchViewModel.getNextPage(searchText: searchText)
                            }
                        }
                default:
                    EmptyView()
                }
            }
        }
        .listStyle(.plain)
        .padding(.top, -16)
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
    
    private func businessListErrorView(error: NetworkError) -> some View {
        VStack(spacing: .zero) {
            Spacer()
            HStack(spacing: .zero) {
                Spacer()
                VStack {
                    Text(error.description)
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
}
