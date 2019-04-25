//
//  ViewController.swift
//  maptest
//
//  Created by Guest2 on 4/11/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    let regionRadius: CLLocationDistance = 500;
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius);
        mapView.setRegion(coordinateRegion, animated: true);
    }
    
    @IBOutlet weak var mapView: MKMapView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: 40.7391728, longitude: -73.9831523);
        centerMapOnLocation(location: initialLocation);
    }

}
