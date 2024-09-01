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
    private var trancribingProcessEstimated = 0.09 // this var is used to predict how much time it takes to process an audio segment
    // We observed that it takes 0.09 seconds to process a segment whose duration is 1 second
    
    init() {
        dateFormatter = DateFormatter()
        date = Date()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        recordName = "Record \(dateFormatter.string(from: date))"
        defaultRecordName = "Record \(dateFormatter.string(from: date))"
        recordFilename = "record\(dateFormatter.string(from: date)).m4a"
        recordFilename = "\(recordFilename.replacingOccurrences(of: " ", with: "").lowercased())"
        recordFilename = "\(recordFilename.replacingOccurrences(of: ":", with: "_").lowercased())"
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
    
    
    
    func getAudioPath(recordFilename: inout String, id: UUID) -> URL? {
        if recordFilename == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
            self.recordFilename = "record\(dateFormatter.string(from: Date.now)).m4a"
            self.recordFilename = "\(self.recordFilename.replacingOccurrences(of: " ", with: "").lowercased())"
            self.recordFilename = "\(self.recordFilename.replacingOccurrences(of: ":", with: "_").lowercased())"
            recordFilename = self.recordFilename
        }
        let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.audioPath = URL(string: (id.uuidString + recordFilename))
        return appDirectory.appendingPathComponent(audioPath!.absoluteString)
    }
    
    func startRecording(id: UUID) {
        setupRecordingSession()
        isRecording = true
        
        let fullAudioPath = getAudioPath(recordFilename: &recordFilename, id: id)
        
        if let audioPath = fullAudioPath {
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
            if let audioPath = fullAudioPath {
                audioRecorder = try AVAudioRecorder(url: audioPath, settings: settings)
                audioRecorder?.record()
                isRecording = true
            }
        } catch {
            finishRecordingHandler(id: id)
        }
    }
    
    func finishRecordingHandler(id: UUID) {
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
        
        do {
            let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = appDirectory.appendingPathComponent(audioPath.absoluteString)
            try FileManager.default.removeItem(at: destinationURL)
            print("Recorded audio file deleted successfully.")
            recorded = false // Reset the recorded flag after deletion
            recLoaded = false
            recordFilename = ""
            self.audioPath = nil
        } catch {
            print("Failed to delete recorded audio file:", error.localizedDescription)
        }
    }
    
    func deleteDocument() {
        guard let docPath = docPath else {
            print("No document found.")
            return
        }
        
        do {
            let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = appDirectory.appendingPathComponent(docPath.absoluteString)
            try FileManager.default.removeItem(at: destinationURL)
            print("Document deleted successfully.")
            textLoaded = false
            docFilename = ""
        } catch {
            print("Failed to delete document:", error)
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
    
    func segmentAudio(audioPath: String, segmentDuration: TimeInterval) -> [URL] {
        // access to the audio file
        let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = appDirectory.appendingPathComponent(audioPath)
        
        let asset = AVAsset(url: url)
        let duration = CMTimeGetSeconds(asset.duration) // get audio duration
        var segments: [URL] = [] // segments' urls array
        
        var currentStartTime: TimeInterval = 0
        while currentStartTime < duration { // segment audio
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
    
    private func createTemporaryURL() -> URL? { // This directory will be used to store audio segments for a limited time
        let tempDirectory = NSTemporaryDirectory()
        let tempFile = UUID().uuidString + ".m4a"
        return URL(fileURLWithPath: tempDirectory).appendingPathComponent(tempFile)
    }
    
    private func exportSegment(asset: AVAsset, timeRange: CMTimeRange, outputURL: URL) -> Bool {
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .m4a
        exportSession?.timeRange = timeRange // cut the audio
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var success = false
        exportSession?.exportAsynchronously { // export
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
    
    // Segment transcription operation
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
            //} else if let result = result {
            //   print(result.bestTranscription.formattedString)
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

    func processAudioFile(audioPath: String, evaluator: Evaluator, completion: @escaping (Bool) -> Void) {
        evaluator.progress = 0 // start transcription operation (a ProgressView will be shown)

        let segments = segmentAudio(audioPath: audioPath, segmentDuration: self.segmentDuration) // audio segmentation
        var recognizedText = ""

        let queue = DispatchQueue(label: "com.expositions.mySerialQueue")
        let semaphore = DispatchSemaphore(value: 1)

        let segmentCount = segments.count
        var i = 0

        for segmentURL in segments {
            var workItem: DispatchWorkItem?

            workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }

                semaphore.wait() // wait for the previous segment to be transcribed

                if workItem?.isCancelled ?? false { // if the user stopped the evaluation, do not continue
                    semaphore.signal() // signal the other threads to continue and stop the process
                    return // stop
                }

                // The following lines of code are used to modify the progress bar
                let targetValue: Float = 1 / Float(segmentCount) * Float(i + 1) // depending on the number of segments
                let duration: TimeInterval = trancribingProcessEstimated * self.getSegDuration(segmentURL: segments[i].absoluteURL) // estimated duration of transcribing process for this segment
                let increment: Float = targetValue / (Float(duration) * 10)

                let timer = DispatchSource.makeTimerSource()
                timer.schedule(deadline: .now(), repeating: 0.1) // increment evaluator's progress every 0.1 seconds
                timer.setEventHandler {
                    DispatchQueue.main.async {
                        evaluator.progress += increment

                        // do not surpass target value or 1.0 (maximum - 100%)
                        if evaluator.progress >= targetValue || evaluator.progress >= 1.0 {
                            evaluator.progress = min(evaluator.progress, 1.0)
                            timer.cancel()
                        }

                        if workItem?.isCancelled ?? false { // if user stopped the evaluation, cancel the timer
                            timer.cancel()
                        }
                    }
                }
                timer.resume()
                evaluator.addTimer(timer)

                self.processAudioSegment(segmentURL: segmentURL) { text in
                    if let text = text {
                        recognizedText += text + " " // build recognizedText segment by segment
                    }
                    self.curSegStartTime += self.getSegDuration(segmentURL: segmentURL)
                    i += 1
                    semaphore.signal()

                    if i == segmentCount { // all segments have been processed
                        self.transcription = recognizedText
                        print("Transcription: \(recognizedText)")
                        completion(true) // complete
                    } else if workItem?.isCancelled ?? false {
                        completion(false)
                    } else {
                        completion(false)
                    }
                }
            }

            if let workItem = workItem {
                evaluator.addWorkItem(workItem)
                queue.async(execute: workItem)
            }
        }
    }
    
    /* UTILITY FUNCTIONS */
    func verifyAudioFile(url: URL) -> Bool {
        
        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Audio file can't be played: \(error)")
            return false
        }
        
        guard let player = audioPlayer else {
            print("Player can't be created")
            return false
        }
        
        player.prepareToPlay()
        if player.duration > 0 {
            print("Valid audio. Duration: \(player.duration) seconds")
            return true
        } else {
            print("Invalid audio")
            return false
        }
    }
    
    func getSegDuration(segmentURL: URL) -> Double {
        var duration: Double = 0.0
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: segmentURL)
            duration = audioPlayer.duration
        } catch {
            print("Audio file loading failed: \(error)")
        }
        return duration
    }

}

struct Duration: Codable {
    var hours: Int
    var minutes: Int
    var seconds: Int
}
