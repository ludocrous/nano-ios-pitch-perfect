//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Derek Crous on 19/05/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer = AVAudioPlayer()
    var receivedAudio : RecordedAudio!
    
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.delegate = self
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        setPlaybackControlsVisibility(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPlaybackControlsVisibility(hidden : Bool) {
        // This function controls the visibility of the stop button
        stopButton.hidden = hidden
    }
    
    func enginePlaybackCompletionHandler() -> () {
        setPlaybackControlsVisibility(true)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: enginePlaybackCompletionHandler)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    

    func playAudioWithReverb(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioReverb = AVAudioUnitReverb()
        audioReverb.wetDryMix = 100
        audioEngine.attachNode(audioReverb)
        
        audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
        audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: enginePlaybackCompletionHandler)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    func playAudioWithEcho(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioEcho = AVAudioUnitDelay()
        audioEcho.wetDryMix = 100
        audioEcho.feedback = 50
        audioEcho.delayTime = 0.5
        audioEngine.attachNode(audioEcho)
        
        audioEngine.connect(audioPlayerNode, to: audioEcho, format: nil)
        audioEngine.connect(audioEcho, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: enginePlaybackCompletionHandler)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0

        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = 0.5
        audioPlayer.play()
        setPlaybackControlsVisibility(false)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0

        audioEngine.stop()
        audioEngine.reset()

        audioPlayer.rate = 2.0
        audioPlayer.play()
        setPlaybackControlsVisibility(false)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        setPlaybackControlsVisibility(false)
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        setPlaybackControlsVisibility(false)
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        setPlaybackControlsVisibility(false)
        playAudioWithReverb()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        setPlaybackControlsVisibility(false)
        playAudioWithEcho()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        setPlaybackControlsVisibility(true)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        setPlaybackControlsVisibility(true)
    }
    

}
