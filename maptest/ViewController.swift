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
    // when redrawing map for updated doctor location, use last known user location for other pt
    
    // userLocation variable not needed, can use mapView.UserLocation();
    //var lastKnownUserLocation = CLLocation(latitude: 0.0, longitude: 0.0);
    var lastKnownDocLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0);
    var activeAlert = false;
    var docMarker = MKPointAnnotation();
    
    @IBOutlet weak var mapView: MKMapView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // let dummyLocation = CLLocation(latitude: 40.7391728, longitude: -73.9831523);
        
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
        mapView.showsUserLocation = true;
        mapView.showsPointsOfInterest = false;
        // title does not seem to move when coordinate changes. removing it i find out how to move them both
        //marker.title = "Doc";
        
        
        // simulating a moving doctor
        // source on delayed execution code: https://stackoverflow.com/questions/28821722/delaying-function-in-swift
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.addDoctorMarker();
            self.lastKnownDocLocation.latitude = 40.740447;
            self.lastKnownDocLocation.longitude = -73.981132;
            self.updateDoctorLoc(docLocation: self.lastKnownDocLocation);
        });
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.lastKnownDocLocation.latitude = 40.740512;
            self.lastKnownDocLocation.longitude = -73.981883;
            self.updateDoctorLoc(docLocation: self.lastKnownDocLocation);
        });
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: {
            self.lastKnownDocLocation.latitude = 40.739939;
            self.lastKnownDocLocation.longitude = -73.982479;
            self.updateDoctorLoc(docLocation: self.lastKnownDocLocation);
        });
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0, execute: {
            self.lastKnownDocLocation.latitude = 40.739321;
            self.lastKnownDocLocation.longitude = -73.982908;
            self.updateDoctorLoc(docLocation: self.lastKnownDocLocation);
        });
        // alert ends, remove doctor marker
        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0, execute: {
            self.removeDoctorMarker();
        });
        
    }
    
    // https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423615-locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
        manager: "location manager obj that generated the update event"
         locations: array of CLLocations. always contains at least 1 element representing current location.
            if updates were deferred or multiple locations arrived before they could be delivered, array contains
            additional entries (in order they occurred. most recent at the end).
        */
        //let mostRecentLocationIndex = locations.count - 1;
        //lastKnownUserLocation = locations[mostRecentLocationIndex];
        
        // when updated user location is received:
            // if there is not a doctor on the way (AKA no active alert), recenter map on new user location
            // if there is an active alert/doctor, recenter map between doctor info and new user info
        if (!activeAlert) {
            centerOnLocation(location: mapView.userLocation.coordinate);
        } else {
            updateDoctorLoc(docLocation: lastKnownDocLocation);
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription);
    }
    
    
    // center map on given loction
    func centerOnLocation(location: CLLocationCoordinate2D) {
        // when only showing the user, use default region radius of 500m.
        //let regionRadius = CLLocationDistance(exactly: 500);
        let regionRadius: CLLocationDistance = 500;
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius);
        mapView.setRegion(coordinateRegion, animated: true);
    }

    func addDoctorMarker() {
        activeAlert = true;
        mapView.addAnnotation(docMarker);
    }
    func removeDoctorMarker() {
        activeAlert = false;
        mapView.removeAnnotation(docMarker);
        centerOnLocation(location: mapView.userLocation.coordinate);
    }
    
    // center map between user and doctor locations, show marker on doc location
    func updateDoctorLoc(docLocation: CLLocationCoordinate2D) {
        let userLocation = mapView.userLocation.coordinate;
        
        // find distance between user and given doctor location to establish regionRadius
            // (creating CLLocations since CLLocationCoordinate2D doesn't have distance function)
        let distanceBetweenCoordinates = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude).distance(from: CLLocation(latitude: docLocation.latitude, longitude: docLocation.longitude));
        // set zoom distance to max of 100m and one computed above (don't want to zoom in too close as doctor approaches)
        let regionRadius = max(distanceBetweenCoordinates, 100);
        
        // update marker position to given coordinates
        docMarker.coordinate = CLLocationCoordinate2D(latitude: docLocation.latitude, longitude: docLocation.longitude);
        
        // recenter map between the two
        var center = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude);
        if (userLocation.latitude > docLocation.latitude) {
            center.latitude += (userLocation.latitude - docLocation.latitude)/2;
        } else {
            center.latitude += (docLocation.latitude - userLocation.latitude)/2;
        }
        if (userLocation.longitude > docLocation.longitude) {
            center.longitude += (userLocation.longitude - docLocation.longitude)/2;
        } else {
            center.longitude += (docLocation.longitude - userLocation.longitude)/2;
        }
        let coordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius);
        mapView.setRegion(coordinateRegion, animated: true);
        
    }
    
}
