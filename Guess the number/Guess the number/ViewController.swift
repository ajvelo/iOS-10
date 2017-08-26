//
//  ViewController.swift
//  Guess the number
//
//  Created by ANDREAS VELOUNIAS on 05/07/2017.
//  Copyright © 2017 mawion. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var count: UILabel!
    
    var bannerView: GADBannerView!

    var guesses = 0
    
    @IBAction func buttonTapped(_ sender: Any) {
        if let textFieldInt: UInt32 = UInt32(textField.text!) {
            
            let number = arc4random_uniform(10)
        
            if textFieldInt > 10 {
                label.text = "Please enter a number between 0 and 10!"
            }
            
            else if textFieldInt == number {
                    label.text = "You're right!"
                    guesses += 1
            }
        
            else if textFieldInt != number {
                    label.text = "Wrong! It was \(number)"
                    guesses = 0
                    count.text = ""
            }
    
            
        }
        else {
        label.text = "Please enter a number!"
        }
        
        if guesses >= 2 {
            count.text = String(guesses) + " correct guesses in a row!"
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
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/5709286947"
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

