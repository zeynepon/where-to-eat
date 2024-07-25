//
//  TabsView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation
import CoreLocationUI

// TODO: Make this an app clip, do some research (nice to have)
// TODO: Have a login feature, integrate with Firebase, Spark plan
// TODO: Add an ad framework. AdMob (after Firebase)
// TODO: Download a video file and store it in documents, put the video file on Firebase and have a link for it that you expose
// -> Download that link, use AV

struct LaunchView: View {
    var viewModel: InitialMapViewModel
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            MapViewRepresentable(coordinate: locationManager.location)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            SearchView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search")
                }
        }
    }
}

struct SearchView: View {
    let viewModel: InitialMapViewModel
    
    var body: some View {
        BusinessListView(viewModel: viewModel)
    }
}
