//
//  ViewController.swift
//  Cat Years
//
//  Created by ANDREAS VELOUNIAS on 30/06/2017.
//  Copyright © 2017 mawion. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate {

    @IBOutlet var label1: UILabel!
    
    @IBOutlet var label2: UILabel!
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var label3: UILabel!
    
    @IBOutlet var label4: UILabel!
    
    var bannerView: GADBannerView!
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        let textFieldInt: Int? = Int(textField.text!)
        
        if textFieldInt != nil {
            let convert = textFieldInt! * 7
            label4.text = String(convert)
        }
            
        else {
        label4.text = "Please enter a number!"
        }
        
        textField.resignFirstResponder()
        
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
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/8303536981"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

