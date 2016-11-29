//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Muhammad Ali on 2016-11-03.
//  Copyright © 2016 RandomBits. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recording: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: AnyObject) {
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func configureUI(isRecording: Bool){
        // Set label
        recording.text =
            isRecording ? "Recording in progress" : "Tap to Record"
        
        // Set buttons
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
    }
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isEnabled = false
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
        print("recording was unsuccessful ...")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

