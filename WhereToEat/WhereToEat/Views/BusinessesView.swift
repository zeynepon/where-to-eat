//
//  BusinessesView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessesView: View {
    // TODO: Add a coordinator :)
    @State private var businesses: [Business] = []
    
    private let viewModel: InitialMapViewModel
    private let searchText: String
    
    init(viewModel: InitialMapViewModel, searchText: String) {
        self.viewModel = viewModel
        self.searchText = searchText
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(businesses, id: \.self) { business in
                    NavigationLink {
                        BusinessView(business: business)
                    } label: {
                        Text(business.name)
                    }
                }
            }
            .task {
                businesses = (try? await viewModel.fetchRestaurants(searchText: searchText)?.businesses) ?? []
            }
            .refreshable {
                businesses = (try? await viewModel.fetchRestaurants(searchText: searchText)?.businesses) ?? []
            }
            .navigationTitle("Businesses")
        }
    }
}
