//
//  ViewController.swift
//  Location Aware
//
//  Created by ANDREAS VELOUNIAS on 26/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMobileAds

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, GADBannerViewDelegate {
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    var bannerView: GADBannerView!

    var manager = CLLocationManager()
    var regionHasBeenSet = false
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-5929336709417945/1918393359"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]

        self.latitudeLabel.text = String(format: "%.5f", location.coordinate.latitude)
        self.longitudeLabel.text = String(format: "%.5f", location.coordinate.longitude)
        self.courseLabel.text = String(format: "%.5f", location.course)
        self.speedLabel.text = String(format: "%.5f", location.speed)
        self.altitudeLabel.text = String(format: "%.5f", location.altitude)
        
        if !regionHasBeenSet {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let latDelta: CLLocationDegrees = 0.05
            let longDelta: CLLocationDegrees = 0.05
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: coordinates, span: span)
            
            self.mapView.setRegion(region, animated: true)
            
            regionHasBeenSet = true
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print(error!)
            }
            
            else {
                if let placemark = placemarks?[0] {
                    var address = ""
                    
                    if placemark.subThoroughfare != nil {
                        address += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        address += placemark.thoroughfare! + "\n"
                    }
                    
                    if placemark.subLocality != nil {
                        address += placemark.subLocality! + "\n"
                    }
                    
                    if placemark.subAdministrativeArea != nil {
                        address += placemark.subAdministrativeArea! + "\n"
                    }
                    
                    if placemark.postalCode != nil {
                        address += placemark.postalCode! + "\n"
                    }
                    
                    if placemark.country != nil {
                        address += placemark.country! + " "
                    }
                    
                    self.addressLabel.text = address
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

