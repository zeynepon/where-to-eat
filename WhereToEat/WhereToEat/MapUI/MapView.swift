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

struct MapView: View {
    @State private var businesses: [Business] = []
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    @State private var isSearching: Bool = false
    @State private var searchText = ""
    
    private var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.locationNames
        } else {
            return viewModel.locationNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @ObservedObject private var locationManager = LocationManager()
    private let viewModel: InitialMapViewModel
    
    public init(viewModel: InitialMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            map
        }
        .searchable(text: $searchText, prompt: "Search for restaurants")
        .onAppear {
            locationManager.manager.requestWhenInUseAuthorization()
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
