//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Derek Crous on 19/05/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var player = AVAudioPlayer()
    
    @IBOutlet weak var stopButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var path = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")!  )
        player = AVAudioPlayer(contentsOfURL: path, error: nil)
        player.enableRate = true
        player.prepareToPlay()
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        player.stop()
        player.rate = 0.5
        player.play()
        stopButton.hidden = false
    }

    @IBAction func playFastAudio(sender: UIButton) {
        player.stop()
        player.rate = 2.0
        player.play()
        stopButton.hidden = false
    }
    @IBAction func stopAudio(sender: UIButton) {
        player.stop()
        player.currentTime = 0.0
        stopButton.hidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
