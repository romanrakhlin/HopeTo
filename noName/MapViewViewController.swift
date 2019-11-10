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
    
    @IBOutlet var InfoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    var currentLocation: MKUserLocation?
    
    var num1: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3415),  "Title" : "Графити основателя яндекс", "Description" : "Одно из творений \n коллектива художников/n Hoodgraff запечатлило /n Nлью Сегаловича сопровождается \n  мотивирующей цитатой основателя.ь ", "interest" : 10]
    var num2: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3097),"Title" : "Здание 2", "Description" : "крутой дом", "interest" : 5]
    var num3: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3097), "Title" : "Здание 3", "Description" : "крутой дом", "interest" : 0]
    var num4: [String: Any] = ["location" : CLLocation(latitude: 59.9082, longitude : 30.3097), "Title" : "Здание 4", "Description" : "крутой дом", "interest" : 10]

    var places: [[String: Any]] = []
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var userLocation = CLLocation()
     var gameTimer: Timer?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var peopleCount: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var descrip: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.isHidden = true
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
       
        
        gameTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        setMarkers()
        checkLocationServices()
    
    }
    
    @objc func runTimedCode(){
        self.places = [num1,num2,num3,num4]
        self.name.isHidden = false
        self.showPlace()
    }

    func setMarkers() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 59.9082, longitude: 30.34157)
        mapView.addAnnotation(annotation)
        let anotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let distanceInMeters = anotationLocation.distance(from: userLocation)
        print(distanceInMeters)
    }
     
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters//kCLLocationAccuracyBest
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
        
    @IBAction func allerOpen(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let yes = UIAlertAction(title: "Я пришел", style: .default) { (action) in
            let alertDelete = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let openAr = UIAlertAction(title: "Открыть Ar", style: .default) { (action) in
                    UIView.animate(withDuration: 0.4) {
                        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
                        self.view.addSubview(blur)
                        blur.frame = self.view.frame
                    }
                }
                let close = UIAlertAction(title: "Тут не интересно", style: .cancel, handler: nil)
                
                alertDelete.addAction(openAr)
                alertDelete.addAction(close)
                
                self.present(alertDelete, animated: true, completion: nil)
            
        }
        
        let no = UIAlertAction(title: "Не пойду", style: .cancel){ (action) in
//            self.locationManager.stopUpdatingLocation()

        }
        
        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
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
        let nearest: CLLocationDistance = 1000000000000000000
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


extension MapViewViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return }
        
//        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
        print(self.getNearestPlace(),"Локация рядом")
        self.showPlace()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func showPlace(){
//        guard let place = self.getNearestPlace() else { return }
        
        let place: [String: Any]
        if self.getNearestPlace() != nil {
            place = self.getNearestPlace()!
        }else{
            locationManager.stopUpdatingLocation()
            return
        }
        let coordinate: CLLocation = place["location"] as! CLLocation

        let nearPlacemark = MKPlacemark(coordinate: coordinate.coordinate)
        let userPlaceMark = MKPlacemark(coordinate: userLocation.coordinate)
        let nearPlacemarkItem = MKMapItem(placemark: nearPlacemark)
        let userPlaceMarkItem = MKMapItem(placemark: userPlaceMark)
        
        
        let request = MKDirections.Request()
        request.source = nearPlacemarkItem
        request.destination = userPlaceMarkItem
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
        self.name.text = (place["Title"] as! String)
        self.descrip.text  = (place["Description"] as! String)
        self.peopleCount.text = "За последнюю неделю \n посетило 6 человек \(Int.random(in: 1...15))"
        

    
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .lightGray
        renderer.lineWidth = 4.0
    
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        currentLocation = userLocation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {

            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let image = UIImage(named: "point")
//        image?. size = CGSize(width: (image?.size.width ?? 25) * 2, height: (image?.size.height ?? 25) * 2)
        annotationView?.image = image
        

        return annotationView
    }
}
