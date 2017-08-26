//
//  ViewController.swift
//  My Sound Shaker
//
//  Created by ANDREAS VELOUNIAS on 31/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        
        if event?.subtype == UIEventSubtype.motionShake {
            
            let soundArray = ["beeper", "bell", "buzzer", "click", "guitar", "hit", "latch", "piano", "piano2", "pop", "punch", "slide", "snap", "tambourine", "tap", "triple", "tv"]
            
            let randomNumber = Int(arc4random_uniform(UInt32(soundArray.count)))
            
            if let fileLocation = Bundle.main.path(forResource: soundArray[randomNumber], ofType: "mp3", inDirectory: "sound effects")
            {
                
                do {
                    
                    try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocation))
                    
                    player.play()
                }
                catch {
                    
                    // process error
                }
                
            }
            
            else {
                print("Error")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
