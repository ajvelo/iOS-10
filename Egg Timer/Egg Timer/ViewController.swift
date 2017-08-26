//
//  ViewController.swift
//  Egg Timer
//
//  Created by ANDREAS VELOUNIAS on 10/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    
    var timer = Timer()
    
    var counter = 210
    
    var bannerView: GADBannerView!

    @IBOutlet var countingLabel: UILabel!
    
    func updateCounter() {
        counter -= 1
        countingLabel.text = String(counter)
        if counter == 0 {
            timer.invalidate()
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        timer.invalidate()
    }
    
    @IBAction func start(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
    }
    
    @IBAction func subtract(_ sender: Any) {
        if counter > 10 {
            counter -= 10
            countingLabel.text = String(counter)
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        timer.invalidate()
        counter = 210
        countingLabel.text = String(counter)
    }
    
    @IBAction func add(_ sender: Any) {
        counter += 10
        countingLabel.text = String(counter)
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        countingLabel.text = String(counter)
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.delegate = self
        
        bannerView.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height - bannerView.frame.size.height - 50)
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/4045029090"
        bannerView.rootViewController = self
        
        //bannerView.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

