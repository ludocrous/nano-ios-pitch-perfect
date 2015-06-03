//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Derek Crous on 15/05/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit
import AVFoundation

var audioRecorder : AVAudioRecorder!
var recordedAudio : RecordedAudio!

// Enumerated type to describe the status of the Recording View
enum RecordingViewStatus {
    case Initial
    case Recording
    case Paused
}


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
   
    // Create a variable to hold the view status and use a property observer to manipulate
    // visibility and enabled status of UI elements
    var viewStatus : RecordingViewStatus = RecordingViewStatus.Initial {
        didSet {
            setViewConfiguration (self.viewStatus)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        viewStatus = RecordingViewStatus.Initial
        
    }
    
    func setViewConfiguration (status : RecordingViewStatus) {
        switch status {
        case .Initial:
            recordLabel.text = "Tap to record"
            recordButton.enabled = true
            
            stopButton.hidden = true
            pauseButton.enabled = true
            pauseButton.hidden = true
            resumeButton.enabled = true
            resumeButton.hidden = true
            
        case .Recording:
            recordButton.enabled = false
            recordLabel.text = "Recording ..."

            stopButton.hidden = false
            pauseButton.hidden = false
            pauseButton.enabled = true
            resumeButton.hidden = false
            resumeButton.enabled = false
        case .Paused:
            recordButton.enabled = false
            recordLabel.text = "Recording paused"

            resumeButton.enabled = true
            pauseButton.enabled = false
        }
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        viewStatus = RecordingViewStatus.Recording
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        //Create unique filename based on timestamp
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Instantiate the audioRecorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        // Pause recording without resetting AudioRecorder
        viewStatus = RecordingViewStatus.Paused
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        // Resume recording
        viewStatus = RecordingViewStatus.Recording
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        viewStatus = RecordingViewStatus.Initial
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }

}

