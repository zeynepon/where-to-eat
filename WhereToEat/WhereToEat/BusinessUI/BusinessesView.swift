//
//  BusinessesView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessesView: View {
    @State private var businesses: [Business] = []
    
    private let viewModel: InitialMapViewModel
    private var searchText: String = ""
    
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
            .onChange(of: searchText, { oldValue, newValue in
                Task { @MainActor in
                    businesses = (try? await viewModel.fetchData(searchText)?.businesses) ?? []
                }
            })
            .refreshable {
                businesses = (try? await viewModel.fetchData(searchText)?.businesses) ?? []
            }
            .navigationTitle("Businesses")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
