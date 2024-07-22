//
//  RecordingManager.swift
//  RecordingPages
//
//  Created by Studente on 12/07/24.
//

import SwiftUI
import Combine
import AVFoundation
import Speech

class RecordingManager: ObservableObject, Codable {
    let dateFormatter: DateFormatter
    let date: Date
    
    @Published var recordName: String   //  Name chosen by the user in the Textfield
    @Published final var defaultRecordName: String  // Name visualized outside of the page if the textfield is empty
    @Published var isRecording: Bool = false    //  true - an audio is being recorded
    @Published var showAlert: Bool = false  //  The alert for save the record must be visualized
    @Published var showErrorAlert: Bool = false //  The error alert must be visualized
    @Published var errorMessage: String = ""    //  The message visualized in the error alert
    @Published var recorded: Bool = false   //  An audio has been recorded
    @Published var recLoaded: Bool = false  //  An audio has been loaded
    @Published var textLoaded: Bool = false //  A document has been loaded
    @Published var docFilename: String = "" //  Document name
    @Published var recordFilename: String = ""  //  Record name
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession1: AVAudioSession?
    private var recordingSession2: AVAudioApplication?
    var audioPath: URL? //  Complete audio path
    var docPath: URL?   // Complete document path
    var duration = Duration(hours: 0, minutes: 0, seconds: 0)   // Duration of the record
    var transcription: String = ""  // Output of the speech to text
    
    init() {
        dateFormatter = DateFormatter()
        date = Date()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        recordName = "Record \(dateFormatter.string(from: date))"
        defaultRecordName = "Record \(dateFormatter.string(from: date))"
        recordFilename = "record\(dateFormatter.string(from: date)).m4a"
        recordFilename = "\(recordFilename.replacingOccurrences(of: " ", with: "").lowercased())"
        setupRecordingSession()
    }
    
    enum CodingKeys: CodingKey {
        case nameKey, dateKey, recordNameKey, audioPathKey, docPathKey, durationKey, transcriptionKey, recordedKey, recLoadedKey, textLoadedKey, docFileNameKey
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recordName, forKey: .nameKey)
        try container.encode(date, forKey: .dateKey)
        try container.encode(recordFilename, forKey: .recordNameKey)
        try container.encodeIfPresent(audioPath, forKey: .audioPathKey)
        try container.encodeIfPresent(docPath, forKey: .docPathKey)
        try container.encode(duration, forKey: .durationKey)
        try container.encode(transcription, forKey: .transcriptionKey)
        try container.encode(recorded, forKey: .recordedKey)
        try container.encode(recLoaded, forKey: .recLoadedKey)
        try container.encode(textLoaded, forKey: .textLoadedKey)
        try container.encode(docFilename, forKey: .docFileNameKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .dateKey)
        dateFormatter = DateFormatter()
        defaultRecordName = "Record \(dateFormatter.string(from: date))"
        recordName = try container.decode(String.self, forKey: .nameKey)
        recordFilename = try container.decode(String.self, forKey: .recordNameKey)
        audioPath = try container.decodeIfPresent(URL.self, forKey: .audioPathKey)
        docPath = try container.decodeIfPresent(URL.self, forKey: .docPathKey)
        duration = try container.decode(Duration.self, forKey: .durationKey)
        transcription = try container.decode(String.self, forKey: .transcriptionKey)
        recorded = try container.decode(Bool.self, forKey: .recordedKey)
        recLoaded = try container.decode(Bool.self, forKey: .recLoadedKey)
        textLoaded = try container.decode(Bool.self, forKey: .textLoadedKey)
        docFilename = try container.decode(String.self, forKey: .docFileNameKey)
    }

    private func setupRecordingSession() {
//        if #available(iOS 17, *) {
//            recordingSession2 = AVAudioApplication.shared
//            recordingSession1 = AVAudioSession.sharedInstance()
//            do{
//                try recordingSession1?.setCategory(.playback)
//                try recordingSession1?.setActive(true)
//            } catch {
//                print("error")
//            }
//            AVAudioApplication.requestRecordPermission { allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        print("Permission granted")
//                    } else {
//                        print("Permission denied")
//                    }
//                }
//            }
//        } else {
            recordingSession1 = AVAudioSession.sharedInstance()

            do {
                try recordingSession1?.setCategory(.playAndRecord, mode: .default)
                try recordingSession1?.setActive(true)
                recordingSession1?.requestRecordPermission { allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            print("Permission granted")
                        } else {
                            print("Permission denied")                        }
                    }
                }
            } catch {
                print("Failed to set up recording session")
            }
        //}
    }



    func startRecording() {
        isRecording = true
        
        guard let resourcePath = Bundle.main.resourcePath else { return }
        audioPath = URL(fileURLWithPath: "\(resourcePath)/\(recordFilename)")

        if let audioPath = audioPath {
            if FileManager.default.fileExists(atPath: audioPath.path) {
                errorMessage = "Something went wrong. Please delete this page and create a new one."
                showErrorAlert = true
                isRecording = false
                print("File already exists.")
                finishRecording(success: false)
                return
            }
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            if let audioPath = audioPath {
                audioRecorder = try AVAudioRecorder(url: audioPath, settings: settings)
                audioRecorder?.record()
                isRecording = true
            }
        } catch {
            finishRecordingHandler()
        }
    }

    func finishRecordingHandler() {
        isRecording = false
        showAlert = true
    }
    
    func finishRecording(success: Bool) {
        guard let resourcePath = Bundle.main.resourcePath else { return }
        audioPath = URL(fileURLWithPath: "\(resourcePath)/\(recordFilename)")
        audioRecorder?.stop()
        audioRecorder = nil
        
        showAlert = false

        if !success {
            // Handle recording failure
            recorded = false
            print("Recording failed")
        } else {
            if let audioPath = self.audioPath {
                recorded = true
                print("FilePath: \(audioPath)")
                requestTranscribePermissions()
                transcribeAudio(url: audioPath)
            }
        }
    }
    
    func deleteRecordedAudio() {
        guard let audioPath = audioPath else {
            print("No recorded audio file found.")
            return
        }

        do {
            try FileManager.default.removeItem(at: audioPath)
            print("Recorded audio file deleted successfully.")
            recorded = false // Reset the recorded flag after deletion
        } catch {
            print("Failed to delete recorded audio file:", error.localizedDescription)
        }
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    func transcribeAudio(url: URL) {
        guard let myRecognizerIT = SFSpeechRecognizer(locale: Locale(identifier: "it_IT")) else {
            print("The recognizer is not supported for the current locale")
            return
        }
        
        if !myRecognizerIT.isAvailable {
            print("The recognizer is not available right now")
            return
        }
        
        let path_to_audio = url
        print(path_to_audio)
        let request = SFSpeechURLRecognitionRequest(url: path_to_audio)
        print("About to create recognition task...")
        
        myRecognizerIT.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                print("Recognition failed, please check the printed error message")
                print(error!)
                return
            }
            if result.isFinal {
                print(result.bestTranscription.formattedString)
                self.transcription = result.bestTranscription.formattedString
            }
        }
    }
    
}

struct Duration: Codable {
    var hours: Int
    var minutes: Int
    var seconds: Int
}

