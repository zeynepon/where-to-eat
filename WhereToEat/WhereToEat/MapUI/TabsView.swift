//
//  TabsView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

import SwiftUI

struct LaunchView: View {
    var searchViewModel: SearchViewModel
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        TabView {
            MapViewRepresentable(favorites: $favoritesViewModel.favorites, coordinate: $locationManager.location)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            SearchView(favoritesViewModel: favoritesViewModel, searchViewModel: searchViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search")
                }
            FavoritesView(viewModel: favoritesViewModel)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favourites")
                }
        }
    }
}

struct SearchView: View {
    let favoritesViewModel: FavoritesViewModel
    let searchViewModel: SearchViewModel
    
    var body: some View {
        BusinessListView(favoritesViewModel: favoritesViewModel, searchViewModel: searchViewModel)
    }
}
