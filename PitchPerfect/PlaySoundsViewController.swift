//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by alejo on 3/10/15.
//  Copyright (c) 2015 alejo software. All rights reserved.
//

import AVFoundation
import UIKit

/// Controller for the screen that plays the sounds
class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    var engine: AVAudioEngine!
    var player: AVAudioPlayer!
    var audioFile: AVAudioFile!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var btnStop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
        
        player = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
        player.delegate = self
        player.enableRate = true
        player.prepareToPlay()
    }
    
    /// Sets the view before it appears on screen
    override func viewWillAppear(animated: Bool) {
        btnStop.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Stops the player from playing the current
    @IBAction func stopPlayer(sender: UIButton) {
        stop()
    }

    /// Plays the audio is a faster speed
    @IBAction func playFast(sender: UIButton) {
        play(2)
    }
    
    /// Plays the audio in a slower speed
    @IBAction func playSlow(sender: UIButton) {
        play(0.3)
    }

    /// Plays the audio as Darth Vader
    @IBAction func darthVader(sender: UIButton) {
        pitch(-1000)
    }
    
    /// Plays the audio as a chipmunk
    @IBAction func chipmunk(sender: UIButton) {
        pitch(1000)
    }

    /// Plays the audio with reverb.
    @IBAction func playReverb(sender: UIButton) {
        reverb()
    }
    

    /// Change the pitch of the audio
    /// It will first stop any playback and then play the requested one.
    ///
    /// :param: pitch The pitch to use to play the audio
    func pitch(pitch: Float) {
        stop()
        btnStop.enabled = true
        var audioPlayerNode = AVAudioPlayerNode()
        engine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        engine.attachNode(changePitchEffect)

        engine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        engine.connect(changePitchEffect, to: engine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    /// Plays the sound with a reverb effect.
    func reverb() {
        stop()
        btnStop.enabled = true
        var audioPlayerNode = AVAudioPlayerNode()
        engine.attachNode(audioPlayerNode)
        
        var reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 50
        engine.attachNode(reverb)
        
        engine.connect(audioPlayerNode, to: reverb, format: nil)
        engine.connect(reverb, to: engine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    /// Change the rate of the audio.
    /// It will first stop any playback and then play the requested one.
    ///
    /// :param: rate The rate to use to play the audio
    func play(rate: Float) {
        stop()
        btnStop.enabled = true
        player.currentTime = 0
        player.rate = rate
        player.play()
    }
    
    /// Stop any playback of audio and reset the audio engine.
    func stop() {
        btnStop.enabled = false
        player.stop()
        engine.stop()
        engine.reset()
    }
    
    // Delegate method that triggers when audio stops playing
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        btnStop.enabled = false
    }
    
}
