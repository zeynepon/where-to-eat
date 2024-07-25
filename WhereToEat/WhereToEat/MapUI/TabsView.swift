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
    @State private var searchText = ""
    var viewModel: InitialMapViewModel
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            MapViewRepresentable(coordinate: locationManager.location)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            SearchView(searchText: $searchText, viewModel: viewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search")
                }
        }
    }
}

struct SearchView: View {
    @Binding var searchText: String
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12),span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    let viewModel: InitialMapViewModel
    
    var body: some View {
        BusinessListView(viewModel: viewModel, searchText: $searchText)
    }
    
    @ViewBuilder
    private var map: some View {
        Map(position: $cameraPosition)
            .navigationTitle("Where to Eat?")
            .navigationBarTitleDisplayMode(.inline)
    }
}
