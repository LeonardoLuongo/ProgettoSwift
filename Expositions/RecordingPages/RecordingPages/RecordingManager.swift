import SwiftUI
import Combine
import AVFoundation
import Speech

class RecordingManager: ObservableObject {
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
    
    /*  Speech to text vars */
    let audioEngine = AVAudioEngine()
    let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task : SFSpeechRecognitionTask!
    var isStart : Bool = false
    var transcription: String = ""  // Output of the speech to text
    //var transcriptionSW: [SingleWord] = nil
    
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
        guard let myRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "it_IT")) else {
            print("The recognizer is not supported for the current locale")
            return
        }
        
        if !myRecognizer.isAvailable {
            print("The recognizer is not available right now")
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        myRecognizer.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                print("Recognition failed, please check the printed error message")
                if let error = error {
                    print(error)
                }
                return
            }
            
            if result.isFinal {
                self.transcription = result.bestTranscription.formattedString
                print(self.transcription ?? "No transcription available")
                
                // Iterate through each segment to get word and timestamp
                for segment in result.bestTranscription.segments {
                    let word = segment.substring
                    let timestamp = segment.timestamp
                    print("\(word):\t\(timestamp) seconds")
                }
            }
        }
    }
    
    
    
}

struct Duration {
    var hours: Int
    var minutes: Int
    var seconds: Int
}
