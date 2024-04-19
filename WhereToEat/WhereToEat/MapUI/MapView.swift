//
//  InitialMapView.swift
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

struct MapView: View {
    @State private var searchText = ""
    @ObservedObject private var locationManager = LocationManager()
    private let viewModel: InitialMapViewModel
    
    private var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.locationNames
        } else {
            return viewModel.locationNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    public init(viewModel: InitialMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            SearchingView(searchText: $searchText, viewModel: viewModel)
        }
        .searchable(text: $searchText, prompt: "Search for restaurants")
        .onAppear {
            locationManager.manager.requestWhenInUseAuthorization()
        }
    }
}

struct SearchingView: View {
    @Environment(\.isSearching) private var isSearching
    @Binding var searchText: String
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12),span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    let viewModel: InitialMapViewModel
    
    var body: some View {
        if isSearching {
            BusinessListView(viewModel: viewModel, searchText: searchText)
        } else {
            map
        }
    }
    
    @ViewBuilder
    private var map: some View {
        Map(position: $cameraPosition)
            .navigationTitle("Where to Eat?")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MapView(viewModel: InitialMapViewModel())
}
