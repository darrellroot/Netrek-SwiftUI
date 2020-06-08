//
//  AudioController.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/8/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation
import Speech

class AudioController: NSObject, SFSpeechRecognizerDelegate {
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    private let audioEngine = AVAudioEngine()
    
    init?(keymapController: KeymapController) {
        super.init()
        debugPrint("activating speech controller")
        speechRecognizer.delegate = self
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            debugPrint("audio session setup failed")
            return nil
        }
        let inputNode = audioEngine.inputNode
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            debugPrint("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
            return nil
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                isFinal = result.isFinal
                debugPrint("speech recorded \(result.bestTranscription.formattedString)")
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
    }
}

