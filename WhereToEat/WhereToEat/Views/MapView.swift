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
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    @State private var searchText = ""
    @State private var pinCount = 0
    
    private var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.locationNames
        } else {
            return viewModel.locationNames.filter { $0.contains(searchText) }
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
                            guard let coordinate = cameraPosition.region?.center else { return }
                            let location = Location(name: "Pin \(pinCount)", coordinate: coordinate)
                            pinCount += 1
                            viewModel.addLocation(location: location)
                        }
                    }
                }
        }
        .searchable(text: $searchText)
    }
}

//#Preview {
//    InitialMapView(viewModel: InitialMapViewModel())
//}
