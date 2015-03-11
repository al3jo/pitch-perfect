//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by alejo on 3/9/15.
//  Copyright (c) 2015 alejo software. All rights reserved.
//

import AVFoundation
import UIKit

/// This class controlls the first (landing) screen of the app
/// It will react to user tabs on the microphone, and display tips and components accordingly
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var isPaused: Bool!

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var btnStopRecording: UIButton!
    @IBOutlet weak var btnPauseRecording: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// If the segue comming is the 'stop recording' one, then set the audio file to it so it can be played
    ///
    /// :param: segue The segue that comes next
    /// :param: sender Who sends the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recordedAudio = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Set up the initial state that the user must see when the view appears
    /// either for the first time or comming from another segue
    override func viewWillAppear(animated: Bool) {
        isPaused = false
        lblRecording.text = "Tab to Record"
        btnStopRecording.hidden = true
        btnPauseRecording.hidden = true
    }

    /// Records the audio when the button is pressed. The audio will be saved on a file, so it can later be replayed.
    ///
    /// :param: sender The button that triggered this action
    @IBAction func recordAudio(sender: UIButton) {
        lblRecording.text = "Recording"
        btnStopRecording.hidden = false
        btnPauseRecording.hidden = false

        if (!isPaused) {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
        }
        isPaused = false
        audioRecorder.record()
    }

    /// Stop recording the audio and reset the screen so the user knows what can be done next
    ///
    /// :param: sender The button that triggered the action.
    @IBAction func stopRecording(sender: UIButton) {
        isPaused = true
        lblRecording.text = "Tap to Record"
        btnStopRecording.hidden = true;
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    /// Pauses the recording of audio
    ///
    /// :param: sender The button that triggered this action
    @IBAction func pauseRecording(sender: UIButton) {
        isPaused = true
        lblRecording.text = "Recording Paused"
        
        audioRecorder.pause()
    }

    /// Callback function triggered when the audio has been recorder, whether or not the operation was successful.
    /// If there was a problem recording the audio, then a message is displayed to the user.
    ///
    /// :param: recorder A reference to the AVAudioRecorder that completed the recording action.
    /// :param: flag true if recording was successful. False otherwise.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        isPaused = false
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: audioRecorder.url, title: audioRecorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Error recording audio"
            alert.addButtonWithTitle("Ok :(")
            alert.show()
        }
    }
    
}