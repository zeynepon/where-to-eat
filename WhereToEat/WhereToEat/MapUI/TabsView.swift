//
//  TabsView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

import SwiftUI

struct LaunchView: View {
    var mapViewModel: MapViewModel
    @ObservedObject var favouritesViewModel: FavouritesViewModel
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            MapViewRepresentable(favourites: $favouritesViewModel.favourites, coordinate: locationManager.location)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            SearchView(favouritesViewModel: favouritesViewModel, mapViewModel: mapViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search")
                }
            FavouritesView(viewModel: favouritesViewModel)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favourites")
                }
        }
    }
}

struct SearchView: View {
    let favouritesViewModel: FavouritesViewModel
    let mapViewModel: MapViewModel
    
    var body: some View {
        BusinessListView(favouritesViewModel: favouritesViewModel, mapViewModel: mapViewModel)
    }
}
