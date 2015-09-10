//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paul Salinas on 2015-08-30.
//  Copyright (c) 2015 Paul Salinas. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the content to be played to the receivedAudio obtained from the segue
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioEngine = AVAudioEngine();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        stopAudio()
    }
    
    @IBAction func playFastAudio(sender: AnyObject) {
        playAudioWithRate(2.0)
    }

    @IBAction func playChipMunkAudio(sender: AnyObject) {
        playAudioWithPitch(1000);
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAudioWithPitch(-1000);
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        playAudioWithReverb();
    }
    
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        playAudioWithEcho();
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithRate(0.3)
    }
    
    /* this function will connect the audioUnit param to the audio engine and play the recorded audio. Used for playing audio with an AVAudioUnit effect.  */
    func playAudioWithEffectsHelper(audioUnit: AVAudioUnit) {
        stopAudio()
        
        var audioNodePlayer = AVAudioPlayerNode()
        audioEngine.attachNode(audioNodePlayer)
        audioEngine.attachNode(audioUnit)
        
        audioEngine.connect(audioNodePlayer, to: audioUnit, format: audioFile.processingFormat)
        audioEngine.connect(audioUnit, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioNodePlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioNodePlayer.play()
        
    }
    
    func playAudioWithPitch(pitch: Float) {
        var timePitch = AVAudioUnitTimePitch()
    
        timePitch.pitch = pitch
        
        playAudioWithEffectsHelper(timePitch)
    }
    
    func playAudioWithReverb() {
        var unitReverb = AVAudioUnitReverb()
        
        unitReverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral);
        unitReverb.wetDryMix = 100;
        
        playAudioWithEffectsHelper(unitReverb)
    }
    
    func playAudioWithEcho() {
        var timeDelay = AVAudioUnitDelay()
        timeDelay.delayTime = 0.2
        
        playAudioWithEffectsHelper(timeDelay)
    }
    
    func playAudioWithRate(rate: Float) {
        stopAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    /* performs the required steps to properly stop the audio */
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
}
