//
//  PlacesViewController.swift
//  Memorable Places
//
//  Created by ANDREAS VELOUNIAS on 27/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import GoogleMobileAds

var places = [Dictionary<String, String>()]

var activePlace = -1

class PlacesViewController: UITableViewController, GADBannerViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var bannerView: GADBannerView!

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.delegate = self
        
        bannerView.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height - bannerView.frame.size.height - 50)
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/5933606087"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            
            places = tempPlaces
        }
        
        if places.count == 1 && places[0].count == 0 {
            
            places.remove(at: 0)
            
            places.append(["name": "Taj Mahal", "lat": "27.175277", "lon": "78.042128"])
            
            UserDefaults.standard.set(places, forKey: "places")
        }
        
        activePlace = -1
        
        table.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            places.remove(at: indexPath.row)
            
            UserDefaults.standard.set(places, forKey: "places")
            
            table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        if places[indexPath.row]["name"] != nil {
            
            cell.textLabel?.text = places[indexPath.row]["name"]
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activePlace = indexPath.row
        
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
