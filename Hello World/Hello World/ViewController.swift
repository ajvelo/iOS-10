//
//  ViewController.swift
//  Hello World
//
//  Created by ANDREAS VELOUNIAS on 29/06/2017.
//  Copyright © 2017 mawion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var label1: UILabel!

    @IBOutlet var textField: UITextField!
  
    @IBOutlet var label2: UILabel!
    
    @IBAction func buttonTapped(_ sender: Any) {
        label2.text = "Hello " + (textField.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

