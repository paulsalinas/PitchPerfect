//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paul Salinas on 2015-08-26.
//  Copyright (c) 2015 Paul Salinas. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    /* each case represents a state in our View */
    enum ViewStates {
        case PreRecording, Recording, Stopped, Paused
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setViewStateTo(ViewStates.PreRecording)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            
            //make sure to bind the recordedAudio to a property to the destination controller
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.receivedAudio = sender as! RecordedAudio
            
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        setViewStateTo(ViewStates.Recording)
        
        //create the file path and file name of where we'll store the recorded audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //setup the audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        setViewStateTo(ViewStates.Stopped)
        
        //stop the audio recorder and deactivate the audio session
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseRecordingAudio(sender: AnyObject) {
        setViewStateTo(ViewStates.Paused)
        
        audioRecorder.pause()
    }
    
    @IBAction func continueRecordingAudio(sender: AnyObject) {
        setViewStateTo(ViewStates.Recording)
        
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            
            //create our model and initiate the segue while passing our model
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("recording was not succesful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    /* this helper function will set the state of the view components appropriately based on the states defined in the ViewStates enum */
    func setViewStateTo(state: ViewStates) {
        switch (state) {
        case .Recording:
            recordingStatus.text = "Recording in progress"
            recordButton.enabled = false
            stopButton.hidden = false
            playButton.hidden = false
            playButton.enabled = false
            pauseButton.enabled = true
            pauseButton.hidden = false
        case .Stopped, .PreRecording:
            stopButton.hidden = true
            recordingStatus.text = "Tap to record"
            recordButton.enabled = true
            pauseButton.hidden = true
            playButton.hidden = true
        case .Paused:
            recordingStatus.text = "Recording is paused"
            playButton.enabled = true
            pauseButton.enabled = false
        }
    }
   
}

