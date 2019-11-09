//
//  MapViewViewController.swift
//  noName
//
//  Created by Anmin on 11/9/19.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var num1: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3097),  "Title" : "Здание 1", "Description" : "крутой дом", "interest" : 10]
    var num2: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3097),"Title" : "Здание 2", "Description" : "крутой дом", "interest" : 5]
    var num3: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3097), "Title" : "Здание 3", "Description" : "крутой дом", "interest" : 0]
    var num4: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3097), "Title" : "Здание 4", "Description" : "крутой дом", "interest" : 10]

    var places: [[String: Any]] = []
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.places = [num1,num2,num3,num4]
        setMarkers()
        checkLocationServices()
        
        
    }
    
    func setMarkers() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 59.9082, longitude: 30.3097)
        mapView.addAnnotation(annotation)
        let anotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let distanceInMeters = anotationLocation.distance(from: userLocation)
        print(distanceInMeters)
    }
     
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
        
        
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
        
        
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
        
        
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func getNearestPlace() -> [String: Any]? {
        let nearest: CLLocationDistance = 1000
        var nearestPlace = [[String: Any]]()
        for place in places{
            let placeCoordinat = place["location"] as! CLLocation
            let distanceInMeters = placeCoordinat.distance(from: userLocation)
            
            if distanceInMeters < nearest{
                nearestPlace.append(place)
            }
        }
        var maxInter = 0
        var placeInter: [String: Any]?
        for place in nearestPlace{
            if (place["interest"] as! Int) > maxInter{
                maxInter = place["interest"] as! Int
                placeInter = place
            }
        }
        if placeInter != nil {
            return placeInter
        } else{
            return nil
        }
    }
    
    
}


extension MapViewViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

