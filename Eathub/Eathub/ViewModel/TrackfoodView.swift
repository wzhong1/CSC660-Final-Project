//
//  TrackfoodModel.swift
//  Eathub
//
//  Created by Wii Zh on 10/30/22.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct MyMapView: UIViewRepresentable {
    typealias mapView = MKMapView

    @Binding var requestLocation: CLLocationCoordinate2D
    
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let region = ContentViewModel()
        
        
        region.checkIfLocationServiceIsEnabled()
        mapView.delegate = context.coordinator
        mapView.setRegion(region.region, animated: true)
        
        let foodLocation = MKPlacemark(coordinate: requestLocation)
        
        let userLocation = MKPlacemark(coordinate: region.locationManager!.location!.coordinate)
        
        let foodAnnotation = MKPointAnnotation()
        foodAnnotation.coordinate = foodLocation.coordinate
        foodAnnotation.title = "Food Item"
        
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userLocation.coordinate
        userAnnotation.title = "User Location"
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: foodLocation)
        request.destination = MKMapItem(placemark: userLocation)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate{response, error in
            guard let route = response?.routes.first else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            mapView.addAnnotations([foodAnnotation,userAnnotation])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)->MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
    }
    
    class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
        var locationManager: CLLocationManager?

        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 71.0, longitude: 63.1), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        func checkIfLocationServiceIsEnabled(){
            if CLLocationManager.locationServicesEnabled(){
                locationManager = CLLocationManager()
                locationManager?.delegate = self
            }else{
                print("Need to enable location service")
            }
        }
        
        private func checkLocAuthirization(){
            guard let locationManager = locationManager else {
                return
            }
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case.restricted:
                print("Your location is restricted due to high crime rate.")
            case.denied:
                print("You denied youe location tracking.")
            case.authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            @unknown default:
                break
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocAuthirization()
        }
        
    }
    
}
