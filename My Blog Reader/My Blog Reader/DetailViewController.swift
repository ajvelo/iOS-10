//
//  DetailViewController.swift
//  My Blog Reader
//
//  Created by ANDREAS VELOUNIAS on 03/08/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    
    var bannerView: GADBannerView!
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        view.addSubview(bannerView)
    }
    
    func configureView() {
        // Update the user interface for the detail item.

        if let detail = self.detailItem {
            
            self.title = detail.value(forKey: "title") as? String
            
            if let blogWebView = self.webView {
                blogWebView.loadHTMLString(detail.value(forKey: "content") as! String, baseURL: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.delegate = self
        
        bannerView.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height - bannerView.frame.size.height)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.text = self.title
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.minimumScaleFactor = 0.5
        navigationItem.titleView = titleLabel
        
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

