//
//  ViewController.swift
//  What's The Weather
//
//  Created by ANDREAS VELOUNIAS on 17/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate {
    
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var textField: UITextField!
    
    var bannerView: GADBannerView!
    
    @IBAction func submit(_ sender: Any) {
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/\(textField.text!.replacingOccurrences(of: " ", with: "-"))/forecasts/latest") {
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            
            if error != nil {
                
                print("Error")
            }
                
            else {
                if let unwrappedData = data {
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            stringSeparator = "</span"
                        
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 1 {
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                            }
                        }
                    }
                }
            }
            if message == ""  {
                message = "Weather could not be found. Please try again."
            }
            
            DispatchQueue.main.sync(execute: {
                self.label.text = message
            })
        }
        
        task.resume()
            
        }
        
        else {
            label.text = "City could not be found."
        }
        
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        bannerView.adUnitID = "ca-app-pub-5929336709417945/9278008623"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

