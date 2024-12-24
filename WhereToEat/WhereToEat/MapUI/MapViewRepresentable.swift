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
        
        let annotations = uiView.annotations.compactMap({ $0 as? UserAnnotation })
        guard annotations.count == favorites.count else {
            updateAnnotations(uiView: uiView, annotations: annotations)
            return
        }
    }
    
    private func updateAnnotations(uiView: MKMapView, annotations: [UserAnnotation]) {
        let annotationTitles = annotations.map { $0.title }
        let favoritesTitles = favorites.map { $0.name }
        if annotationTitles.count > favoritesTitles.count {
            let titlesToRemove = annotationTitles.filter { !favoritesTitles.contains($0 ?? "") }
            let annotationsToRemove = annotations.filter { titlesToRemove.contains($0.title) }
            uiView.removeAnnotations(annotationsToRemove)
        } else {
            let titlesToAdd = favoritesTitles.filter { !annotationTitles.contains($0) }
            let favoritesToAdd = favorites.filter { titlesToAdd.contains($0.name) }
            let annotationsToAdd = favoritesToAdd.map { business in
                UserAnnotation(title: business.name,
                               subtitle: business.location.zip_code,
                               coordinate: CLLocationCoordinate2D(latitude: business.coordinates.latitude,
                                                                  longitude: business.coordinates.longitude))
            }
            uiView.addAnnotations(annotationsToAdd)
        }
    }
}

class UserAnnotation: NSObject, MKAnnotation {
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
