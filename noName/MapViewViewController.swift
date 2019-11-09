//
//  MapViewViewController.swift
//  noName
//
//  Created by Anmin on 11/9/19.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }
    
    func setUp(){
        self.centerMapOnLocation(location: initialLocation)
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: self.regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
    }
    

}

extension MapViewViewController{
    
}
