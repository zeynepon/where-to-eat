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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    @State private var searchText = ""
    @State private var pinCount = 0
    @State private var showAddLocationAlert = false
    @State private var locationText = ""
    
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
            Map(position: $cameraPosition)
                .searchable(text: $searchText, prompt: "Search for restaurants") {
                    NavigationLink {
                        BusinessesView(viewModel: viewModel, searchText: searchText)
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
        }
        .onAppear {
            locationManager.manager.requestWhenInUseAuthorization()
        }
    }
}

//#Preview {
//    InitialMapView(viewModel: InitialMapViewModel())
//}
