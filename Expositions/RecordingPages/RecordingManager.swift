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
    @Published var recordPermissionGranted: Bool = false    //  Record permission
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
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "it-IT"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask?
    var isStart: Bool = false
    var transcription: String = ""
    
    private var curSegStartTime = 0.0
    private var segmentDuration = 200.0
    
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
        if #available(iOS 17, *) {
            recordingSession2 = AVAudioApplication.shared
            recordingSession1 = AVAudioSession.sharedInstance()
            AVAudioApplication.requestRecordPermission {
                isPermissionGranted in
                print(isPermissionGranted)
                if !isPermissionGranted {
                    self.recordPermissionGranted = false
                    print("Permission denied")
                    return
                }
                print("Permission granted")
                self.recordPermissionGranted = true
                do{
                    try self.recordingSession1?.setCategory(.playAndRecord, mode: .default)
                    try self.recordingSession1?.setActive(true)
                } catch {
                    print("error")
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
                            self.recordPermissionGranted = true
                    } else {
                        print("Permission denied")
                            self.recordPermissionGranted = false
                        }
                }
            }
        } catch {
                print("Failed to set up recording session")
            }
        }
    }
    
    func requestRecordPermission() {
        setupRecordingSession()
        }
    
    
    
    func getAudioPath(recordFilename: String) -> URL? {
        let resourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let resourcePath = resourcePaths[0]
        audioPath = resourcePath.appendingPathComponent(recordFilename)
        return audioPath
    }
    
    func startRecording() {
        isRecording = true
        
        audioPath = getAudioPath(recordFilename: recordFilename)
        
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
        audioPath = getAudioPath(recordFilename: recordFilename)
        audioRecorder?.stop()
        audioRecorder = nil
        
        isRecording = false
        showAlert = true
    }
    
    func finishRecording(success: Bool) {
        showAlert = false
        
        if !success {
            // Handle recording failure
            recorded = false
            print("Recording failed")
        } else {
            if let audioPath = self.audioPath {
                recorded = true
                print("FilePath: \(audioPath)")
            }
        }
    }
    
    func deleteRecordedAudio() {
        guard let audioPath = audioPath else {
            print("No recorded audio file found.")
            return
        }
        
        guard audioPath.startAccessingSecurityScopedResource() else {
            print("Permission denied to access the file at \(audioPath)")
            return
        }
        
        defer {
            audioPath.stopAccessingSecurityScopedResource()
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
    
    func segmentAudio(url: URL, segmentDuration: TimeInterval) -> [URL] {
        guard url.startAccessingSecurityScopedResource() else {
            print("Permission denied to access the file at \(url)")
            return []
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        let asset = AVAsset(url: url)
        let duration = CMTimeGetSeconds(asset.duration)
        var segments: [URL] = []
        
        var currentStartTime: TimeInterval = 0
        while currentStartTime < duration {
            let endTime = min(currentStartTime + segmentDuration, duration)
            let timeRange = CMTimeRange(start: CMTime(seconds: currentStartTime, preferredTimescale: 600), end: CMTime(seconds: endTime, preferredTimescale: 600))
            
            if let outputURL = createTemporaryURL() {
                let success = exportSegment(asset: asset, timeRange: timeRange, outputURL: outputURL)
                if success {
                    segments.append(outputURL)
                }
            }
            currentStartTime += segmentDuration
        }
        return segments
    }
    
    private func createTemporaryURL() -> URL? {
        let tempDirectory = NSTemporaryDirectory()
        let tempFile = UUID().uuidString + ".m4a"
        return URL(fileURLWithPath: tempDirectory).appendingPathComponent(tempFile)
    }
    
    private func exportSegment(asset: AVAsset, timeRange: CMTimeRange, outputURL: URL) -> Bool {
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .m4a
        exportSession?.timeRange = timeRange
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var success = false
        exportSession?.exportAsynchronously {
            if exportSession?.status == .completed {
                success = true
            } else {
                print("Export failed: \(String(describing: exportSession?.error))")
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return success
    }
    
    func processAudioSegment(segmentURL: URL, completion: @escaping (String?) -> Void) {
        guard verifyAudioFile(url: segmentURL) else { return }
        
        guard let myRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "it_IT")) else {
            print("The recognizer is not supported for the current locale")
            return
        }
        
        if !myRecognizer.isAvailable {
            print("The recognizer is not available right now")
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: segmentURL)
        
        myRecognizer.recognitionTask(with: request) { (result, error) in
            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
                completion(nil)
            } else if let result = result, result.isFinal {
                self.transcription += result.bestTranscription.formattedString
                print(self.transcription ?? "No transcription available")
                
                // Iterate through each segment to get word and timestamp
                for segment in result.bestTranscription.segments {
                    let word = segment.substring
                    let timestamp = segment.timestamp + self.curSegStartTime
                    print("\(word):\t\(timestamp) seconds")
                }
                completion(self.transcription)
            }
        }
    }

    func processAudioFile(url: URL, evaluator: Evaluator, completion: @escaping (Bool) -> Void) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Permission denied to access the file at \(url)")
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        evaluator.progress = 0
        
        let segments = segmentAudio(url: url, segmentDuration: self.segmentDuration) // Segmenti di 500 secondi
        var recognizedText = ""
        
        let queue = DispatchQueue(label: "com.example.mySerialQueue")
        let semaphore = DispatchSemaphore(value: 1) // Limit the number of concurrent tasks
        
        let segmentCount = segments.count
        var i = 0
        
        for segmentURL in segments {
            queue.async {
                semaphore.wait() // Wait for a signal before starting a new task
                self.processAudioSegment(segmentURL: segmentURL) { text in
                    DispatchQueue.main.async {
                        if let text = text {
                            recognizedText += text + " "
                        }
                        self.curSegStartTime += self.getSegDuration(segmentURL: segmentURL)
                        i += 1
                        evaluator.progress = Float(i) / Float(segmentCount)
                        semaphore.signal() // Signal the semaphore when this task is done
                        
                        if i == segmentCount {
                            self.transcription = recognizedText
                            print("Transcription: \(recognizedText)")
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
            }
        }
    }


    func verifyAudioFile(url: URL) -> Bool {
        
        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Non è possibile riprodurre l'audio: \(error)")
            return false
        }
        
        guard let player = audioPlayer else {
            print("Non è stato possibile creare il lettore audio")
            return false
        }
        
        player.prepareToPlay()
        if player.duration > 0 {
            print("L'audio è valido, durata: \(player.duration) secondi")
            return true
        } else {
            print("L'audio non è valido")
            return false
        }
    }
    
    func getSegDuration(segmentURL: URL) -> Double {
        var duration: Double = 0.0
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: segmentURL)
            duration = audioPlayer.duration
        } catch {
            print("Errore nel caricamento del file audio: \(error)")
        }
        return duration
    }

}

struct Duration: Codable {
    var hours: Int
    var minutes: Int
    var seconds: Int
}
