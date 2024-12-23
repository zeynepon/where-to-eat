//
//  FavoritesView.swift
//  WhereToEat
//
//  Created by Zeynep on 08/09/2024.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if !viewModel.favorites.isEmpty {
            NavigationStack {
                List {
                    ForEach(viewModel.favorites, id: \.self) { favorite in
                        NavigationLink {
                            BusinessView(business: favorite, viewModel: BusinessViewModel(business: favorite, favoritesViewModel: viewModel))
                        } label: {
                            Text(favorite.name)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.remove(at: indexSet)
                    }
                }
                .navigationTitle("Favourites")
            }
        } else {
            VStack {
                Text("You have no favourites at the moment")
                    .bold()
                    .font(.title)
                    .fontDesign(.serif)
                    .multilineTextAlignment(.center)
                Text("Add a favourite by searching restaurants in the search tab 🔎")
                    .font(.headline)
                    .fontDesign(.serif)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
