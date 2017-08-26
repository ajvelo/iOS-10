//
//  WeatherTableViewController.swift
//  Weather Forecast
//
//  Created by ANDREAS VELOUNIAS on 04/08/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMobileAds

class WeatherTableViewController: UITableViewController, UISearchBarDelegate, GADBannerViewDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var forecastData = [Weather]()
    var bannerView: GADBannerView!
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        tableView.tableFooterView?.frame = bannerView.frame
        tableView.tableFooterView = bannerView
        
        view.addSubview(bannerView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/2022937773"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            
            if error == nil {
                
                if let location = placemarks?.first?.location {
                    
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        
                        if let weatherData = results {
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        
        return dateFormatter.string(from: date!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var weatherObject = forecastData[indexPath.section]
        let summarySplit = weatherObject.summary.components(separatedBy: "." )
        let summarySplit2 = weatherObject.summary.components(separatedBy: ",")
        
        for _ in indexPath {
            
            if weatherObject.summary.contains(".") {
                weatherObject.summary = summarySplit[0]
            }
                
            else if weatherObject.summary.contains(",") {
                weatherObject.summary = summarySplit2[0]
            }
        }

        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int((weatherObject.temperature - 32) * (5/9))) °C"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        
        return cell
    }
}
