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
                .navigationTitle(String(localized: "Favorites"))
            }
        } else {
            VStack {
                Text(String(localized: "You have no favorites at the moment"))
                    .bold()
                    .font(.title)
                Text(String(localized: "Add a favorite by searching restaurants in the search tab 🔎"))
                    .font(.headline)
            }
            .fontDesign(.serif)
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
