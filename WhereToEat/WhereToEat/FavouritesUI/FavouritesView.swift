//
//  FavouritesView.swift
//  WhereToEat
//
//  Created by Zeynep on 08/09/2024.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject private var viewModel: FavouritesViewModel
    
    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if !viewModel.favourites.isEmpty {
            NavigationStack {
                List {
                    ForEach(viewModel.favourites, id: \.self) { favourite in
                        NavigationLink {
                            BusinessView(business: favourite, viewModel: BusinessViewModel(business: favourite, favouritesViewModel: viewModel))
                        } label: {
                            Text(favourite.name)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.remove(at: indexSet)
                    }
                }
                .navigationTitle("Favourites")
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            VStack {
                Text("You have no favourites at the moment")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text("Add a favourite by searching restaurants in the search tab 🔎")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    FavouritesView(viewModel: FavouritesViewModel())
}
