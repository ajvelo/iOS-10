//
//  ViewController.swift
//  Times Table
//
//  Created by ANDREAS VELOUNIAS on 11/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {

    @IBOutlet var slider: UISlider!
    
    @IBOutlet var table: UITableView!
    
    var bannerView: GADBannerView!
    
    @IBAction func sliderChanged(_ sender: Any) {
        table.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String((Int(slider.value * 20)) * (indexPath.row + 1))
        return cell
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.delegate = self
        
        bannerView.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height - bannerView.frame.size.height)
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/9397250512"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

