//
//  ViewController.swift
//  maptest
//
//  Created by Guest2 on 4/11/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager();
    
    @IBOutlet weak var mapView: MKMapView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dummyLocation = CLLocation(latitude: 40.7391728, longitude: -73.9831523);
        
        // ask user for permission to always use location
        locationManager.requestAlwaysAuthorization();
        locationManager.requestWhenInUseAuthorization();
        // if location services are allowed, start getting user location
        if (CLLocationManager.locationServicesEnabled()) {
            // set delegate, accuracy
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            
            locationManager.startUpdatingLocation();
        }
        
    }
    
    // https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423615-locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
        manager: "location manager obj that generated the update event"
        locationsarray of CLLocations. always contains at least 1 element representing current location
            if updates were deferred or multiple locations arrived before they could be delivered, array contains
            additional entries (in order they occurred. most recent at the end).
        */
        let mostRecentLocationIndex = locations.count;
        let mostRecentLocation  = locations[mostRecentLocationIndex - 1];
        NSLog("location found");
        centerOnLocation(location: mostRecentLocation);
    }
    
    // center map at given coordinates
    func centerOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 500;
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius);
        mapView.setRegion(coordinateRegion, animated: true);
    }
    
    // draw markers for two locations, and center map between them
    func showTwoPoints(location1: CLLocation, location2: CLLocation) {
        
    }
    

}
