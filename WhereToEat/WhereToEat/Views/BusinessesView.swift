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
    
    init(viewModel: InitialMapViewModel) {
        self.viewModel = viewModel
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
                businesses = (try? await viewModel.fetchRestaurants()?.businesses) ?? []
            }
            .navigationTitle("Businesses")
        }
    }
}
