//
//  InitialMapView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
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
    
    private let viewModel: InitialMapViewModel
    
    public init(viewModel: InitialMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            if(!searchText.isEmpty) {
                Spacer()
                ForEach(searchResults, id: \.self) { searchResult in
                    NavigationLink {
                        Text(searchResult)
                    } label: {
                        Text(searchResult)
                    }
                }
            }
            Map(position: $cameraPosition)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add location") {
                            showAddLocationAlert.toggle()
                        }
                        .alert("Add location", isPresented: $showAddLocationAlert) {
                            TextField("Add a location", text: $locationText)
                            Button("OK") {
                                viewModel.addLocation(location: MapLocation(name: locationText, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)))
                                locationText = ""
                            }
                        } message: {
                            Text("Please enter the name of the location you want to save.")
                        }
                    }
                }
            NavigationLink {
                BusinessesView(viewModel: viewModel)
            } label: {
                Text("Show restaurants")
            }
        }
        .searchable(text: $searchText)
    }
}

//#Preview {
//    InitialMapView(viewModel: InitialMapViewModel())
//}
