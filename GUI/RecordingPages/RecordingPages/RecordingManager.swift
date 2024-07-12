//
//  RecordingManager.swift
//  RecordingPages
//
//  Created by Studente on 12/07/24.
//

import SwiftUI
import Combine
import AVFoundation

class RecordingManager: ObservableObject {
    let dateFormatter: DateFormatter
    let date: Date
    @Published var recordName: String
    @Published final var defaultRecordName: String
    @Published var isRecording: Bool = false
    @Published var showAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var recorded: Bool = false
    @Published var textLoaded: Bool = false
    @Published var docName: String = ""
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession1: AVAudioSession?
    private var recordingSession2: AVAudioApplication?
    var recordFilename: String
    var audioPath: URL?
    var docPath: URL?
    var duration = Duration(hours: 0, minutes: 0, seconds: 0)
    
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

    private func setupRecordingSession() {
        if #available(iOS 17, *) {
            recordingSession2 = AVAudioApplication.shared
            
            AVAudioApplication.requestRecordPermission { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Permission granted")
                    } else {
                        print("Permission denied")
                    }
                }
            }
        } else {
            recordingSession1 = AVAudioSession.sharedInstance()

            do {
                try recordingSession1?.setCategory(.playAndRecord, mode: .default)
                try recordingSession1?.setActive(true)
                recordingSession1?.requestRecordPermission { allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            print("Permission granted")
                        } else {
                            print("Permission denied")
                        }
                    }
                }
            } catch {
                print("Failed to set up recording session")
            }
        }
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
                print("Filename: \(audioPath)")
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
}

struct Duration {
    var hours: Int
    var minutes: Int
    var seconds: Int
}
