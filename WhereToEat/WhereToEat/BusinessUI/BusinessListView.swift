//
//  BusinessListView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessListView: View {
    @State private var businesses: [Business] = []
    
    private let viewModel: InitialMapViewModel
    private var searchText: Binding<String>
    
    init(viewModel: InitialMapViewModel, searchText: Binding<String>) {
        self.viewModel = viewModel
        self.searchText = searchText
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(businesses, id: \.self) { business in
                    NavigationLink {
                        BusinessView(business: business, viewModel: BusinessViewModel())
                    } label: {
                        Text(business.name)
                    }
                }
            }
            .onChange(of: searchText.wrappedValue, { oldValue, newValue in
                Task { @MainActor in
                    businesses = (try? await viewModel.fetchData(searchText.wrappedValue)?.businesses) ?? []
                }
            })
            .refreshable {
                businesses = (try? await viewModel.fetchData(searchText.wrappedValue)?.businesses) ?? []
            }
            .searchable(text: searchText)
            .navigationTitle("Businesses")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
