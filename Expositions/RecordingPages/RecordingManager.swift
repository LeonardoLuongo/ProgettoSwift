import SwiftUI
import Combine
import AVFoundation
import Speech

class RecordingManager: ObservableObject, Codable {
    let dateFormatter: DateFormatter
    let date: Date
    
    @Published var recordName: String
    @Published final var defaultRecordName: String
    @Published var isRecording: Bool = false
    @Published var showAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var recorded: Bool = false
    @Published var recLoaded: Bool = false
    @Published var textLoaded: Bool = false
    @Published var docFilename: String = ""
    @Published var recordFilename: String = ""
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession?
    var audioPath: URL?
    var docPath: URL?
    var duration = Duration(hours: 0, minutes: 0, seconds: 0)
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "it-IT"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask?
    var isStart: Bool = false
    var transcription: String = ""
    
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
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Permission granted")
                    } else {
                        print("Permission denied")
                    }
                }
            }
        } catch {
            print("Failed to set up recording session: \(error.localizedDescription)")
        }
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
            recorded = false
            print("Recording failed")
        } else {
            if let audioPath = self.audioPath {
                recorded = true
                print("FilePath: \(audioPath)")
                requestTranscribePermissions()
                processAudioFile(url: audioPath)
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
                self.transcription = result.bestTranscription.formattedString
                print(self.transcription ?? "No transcription available")
                
                // Iterate through each segment to get word and timestamp
                for segment in result.bestTranscription.segments {
                    let word = segment.substring
                    let timestamp = segment.timestamp
                    print("\(word):\t\(timestamp) seconds")
                }
                completion(self.transcription)
            }
        }
    }

    func processAudioFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Permission denied to access the file at \(url)")
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        let segments = segmentAudio(url: url, segmentDuration: 100) // Segmenti di 100 secondi
        var recognizedText = ""
        
        let queue = DispatchQueue(label: "com.example.mySerialQueue")
        let semaphore = DispatchSemaphore(value: 1) // Limit the number of concurrent tasks
        for segmentURL in segments {
            queue.async {
                semaphore.wait() // Wait for a signal before starting a new task
                self.processAudioSegment(segmentURL: segmentURL) { text in
                    DispatchQueue.main.async {
                        if let text = text {
                            recognizedText += text + " "
                        }
                        semaphore.signal() // Signal the semaphore when this task is done
                    }
                }
            }
        }
        
        queue.async {
            self.transcription = recognizedText
            print("Transcription: \(recognizedText)")
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

}

struct Duration: Codable {
    var hours: Int
    var minutes: Int
    var seconds: Int
}
