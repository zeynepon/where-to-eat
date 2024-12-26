//
//  WhereToEatApp.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

// icon: <a target="_blank" href="https://icons8.com/illustrations/illustration/636007d77ae331000128d831">App</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>

import SwiftUI

@main
struct WhereToEatApp: App {
    @StateObject var locationManager: LocationManager
    @StateObject var favoritesViewModel: FavoritesViewModel
    @StateObject var searchViewModel: SearchViewModel
    
    init() {
        self._locationManager = StateObject(wrappedValue: LocationManager())
        self._favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel())
        self._searchViewModel = StateObject(wrappedValue: SearchViewModel(network: Network()))
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView(searchViewModel: searchViewModel,
                       favoritesViewModel: favoritesViewModel,
                       locationManager: locationManager)
        }
    }
}
