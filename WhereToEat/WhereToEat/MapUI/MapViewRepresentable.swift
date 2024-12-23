//
//  MapViewRepresentable.swift
//  WhereToEat
//
//  Created by Zeynep on 25/07/2024.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    typealias UIViewType = MKMapView
    @Binding var favorites: [Business]
    let coordinate: CLLocationCoordinate2D?
    @State private var userCentered: Bool = false
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(with: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        view.showsUserLocation = true
        
        let annotations = favorites.map { business in
            UserAnnotation(title: business.name,
                           subtitle: business.location.zip_code,
                           coordinate: CLLocationCoordinate2D(latitude: business.coordinates.latitude,
                                                              longitude: business.coordinates.longitude))
        }
        
        view.addAnnotations(annotations)
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate, !userCentered {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            uiView.setRegion(region, animated: true)
            Task { @MainActor in
                userCentered.toggle()
            }
        }
    }
}

class UserAnnotation: NSObject, MKAnnotation {
    // TODO: Add annotations according to favourites
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapView: MapViewRepresentable
    
    init(with view: MapViewRepresentable) {
        self.mapView = view
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "_customAnnotationView")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(systemName: "fork.knife.circle.fill")
        return annotationView
    }
}
