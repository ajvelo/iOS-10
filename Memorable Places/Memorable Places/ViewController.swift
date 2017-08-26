//
//  ViewController.swift
//  Memorable Places
//
//  Created by ANDREAS VELOUNIAS on 27/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var manager = CLLocationManager()
    var regionHasBeenSet = false

    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
        if activePlace == -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        
        else {
        
            //Get place details to display on map.
            
            if !regionHasBeenSet {
                
                if places.count > activePlace {
                    
                    if let name = places[activePlace]["name"] {
                        
                        if let lat = places[activePlace]["lat"] {
                            
                            if let lon = places[activePlace]["lon"] {
                                
                                if let latitude = Double(lat) {
                                    
                                    if let longitude = Double(lon) {
                                        
                                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                        
                                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                        
                                        self.map.setRegion(region, animated: true)
                                        
                                        let annotation = MKPointAnnotation()
                                        
                                        annotation.coordinate = coordinate
                                        
                                        annotation.title = name
                                        
                                        self.map.addAnnotation(annotation)
                                        
                                        regionHasBeenSet = true
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        regionHasBeenSet = false
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchpoint = gestureRecognizer.location(in: self.map)
            
            let newCoordinate = self.map.convert(touchpoint, toCoordinateFrom: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    print(error!)
                }
                
                else {
                    
                    if let placemark = placemarks?[0] {
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare! + " "
                        }
                        
                        if placemark.thoroughfare != nil {
                            
                            title += placemark.thoroughfare! + " "
                        }
                        
                        if placemark.administrativeArea != nil {
                            
                            title += placemark.administrativeArea! + " "
                        }
                        
                        if placemark.country != nil {
                            
                            title += placemark.country! + " "
                        }
                    }
                }
                
                if title == "" {
                    
                    title = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
                places.append(["name": title, "lat": String(newCoordinate.latitude), "lon": String(newCoordinate.longitude)])
                
                UserDefaults.standard.set(places, forKey: "places")
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        regionHasBeenSet = false
        
        if !regionHasBeenSet {
            
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.map.setRegion(region, animated: true)
            
            regionHasBeenSet = true
            
            manager.stopUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

