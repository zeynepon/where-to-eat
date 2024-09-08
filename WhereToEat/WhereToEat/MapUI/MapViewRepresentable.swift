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
    let annotations: [UserAnnotation] = UserAnnotation.mock()
    let coordinate: CLLocationCoordinate2D?
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(with: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            uiView.setRegion(region, animated: true)
        }
        
        uiView.addAnnotations(annotations)
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
    
    static func mock() -> [UserAnnotation] {
        let mock1 = UserAnnotation(title: "Woolwich", coordinate: CLLocationCoordinate2D(latitude: 51.495200018068196, longitude: 0.07062379154450647))
        let mock2 = UserAnnotation(title: "Falconwood", coordinate: CLLocationCoordinate2D(latitude: 51.459093419059485, longitude: 0.079453325742332))
        let mock3 = UserAnnotation(title: "Grove Park", coordinate: CLLocationCoordinate2D(latitude: 51.43174118011908, longitude: 0.021618390027477383))
        let mock4 = UserAnnotation(title: "Crystal Palace", coordinate: CLLocationCoordinate2D(latitude: 51.41817246879855, longitude: -0.07284696206531775))
        let mock5 = UserAnnotation(title: "Streatham Common", coordinate: CLLocationCoordinate2D(latitude: 51.41865731393407, longitude: -0.13591650845867925))
        let mock6 = UserAnnotation(title: "Wimbledon Park", coordinate: CLLocationCoordinate2D(latitude: 51.434495021761805, longitude: -0.19941466059001567))
        let mock7 = UserAnnotation(title: "Richmond", coordinate: CLLocationCoordinate2D(latitude: 51.463426824784484, longitude: -0.3016496434016886))
        return [mock1, mock2, mock3, mock4, mock5, mock6, mock7]
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapView: MapViewRepresentable
    
    init(with view: MapViewRepresentable) {
        self.mapView = view
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "_customAnnotationView")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(systemName: "fork.knife.circle.fill")
        return annotationView
    }
}
