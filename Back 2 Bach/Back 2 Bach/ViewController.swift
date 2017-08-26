//
//  ViewController.swift
//  Back 2 Bach
//
//  Created by ANDREAS VELOUNIAS on 28/07/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var time: UILabel!
    @IBOutlet var sound: UILabel!

    
    var player = AVAudioPlayer()
    var timer = Timer()
    let audioPath = Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    func updateScrubber() {
        
        scrubberSlider.value = Float(player.currentTime)
        time.text = String(Int(player.currentTime))
    }

    @IBAction func play(_ sender: Any) {
        
        player.play()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateScrubber), userInfo: nil, repeats: true)
        
        time.text = String(Int(player.currentTime))
        sound.text = String(format: "%.2f", volume.value)
    }
    
    @IBOutlet var volume: UISlider!
    
    @IBOutlet var scrubberSlider: UISlider!
    
    @IBAction func pause(_ sender: Any) {
        
        player.pause()
        timer.invalidate()
    }

    @IBAction func stop(_ sender: Any) {
        
        timer.invalidate()
        player.pause()
        player.currentTime = 0
        scrubberSlider.value = 0
        time.text = String(Int(player.currentTime))
    }
    
    @IBAction func volume(_ sender: Any) {
        
        player.volume = volume.value
        sound.text = String(format: "%.2f", volume.value)
    }
    
    @IBAction func scrubber(_ sender: Any) {
        
        player.stop()
        player.currentTime = TimeInterval(scrubberSlider.value)
        player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        
        catch {
            //Process any errors
        }
        
        scrubberSlider.maximumValue = Float(player.duration)
        
        time.text = "Time (seconds)"
        sound.text = "Volume"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

