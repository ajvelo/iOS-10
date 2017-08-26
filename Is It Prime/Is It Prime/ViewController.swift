//
//  ViewController.swift
//  Is It Prime
//
//  Created by ANDREAS VELOUNIAS on 06/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate {

    @IBOutlet var textField: UITextField!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var number: UILabel!
    
    @IBOutlet var check: UILabel!
    
    var bannerView: GADBannerView!
    
    @IBAction func button(_ sender: Any) {
        
        var isPrime = true
        
        var i: UInt64 = 2
        
        if let textFieldInt: UInt64 = UInt64(textField.text!) {
            if (textFieldInt == 0 || textFieldInt == 1) {
                isPrime = false
            }
            
            else if textFieldInt == 2 {
                isPrime = true
            }
            while i < textFieldInt {
                if textFieldInt % i == 0 {
                    isPrime = false
                    break
                    
                }
                i+=1
            }
            
        
            if isPrime == true {
                label.text = "Your number..."
                number.text = String(textFieldInt)
                check.textColor = UIColor.red
                check.text = "Is Prime!"
            }
                
            else {
                label.text = "Your number..."
                number.text = String(textFieldInt)
                check.textColor = UIColor.black
                check.text = "Is Not Prime!"
            }
            
        }
        else {
            label.text = "Please enter a number!"
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
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/6882945427"
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

