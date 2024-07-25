//
//  BusinessListView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessListView: View {
    @StateObject var viewModel: InitialMapViewModel
    
    init(viewModel: InitialMapViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if let businesses = viewModel.businesses {
                    ForEach(businesses, id: \.self) { business in
                        NavigationLink {
                            BusinessView(business: business, viewModel: BusinessViewModel())
                        } label: {
                            Text(business.name)
                        }
                    }
                } else if viewModel.showErrorScreen {
                    businessListErrorView
                }
            }
            .refreshable { await fetchBusinesses() }
            .searchable(text: $viewModel.searchText)
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
            viewModel.businesses = try await viewModel.fetchData(viewModel.searchText).businesses
        } catch {
            viewModel.showErrorScreen = true
        }
    }
}
