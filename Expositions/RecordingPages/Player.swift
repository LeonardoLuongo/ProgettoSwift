import SwiftUI
import AVFoundation

struct Player: View {
    @ObservedObject var recordingManager: RecordingManager
    @State private var player: AVPlayer?
    @State private var playerItem: AVPlayerItem?
    @State private var playerObserver: Any?
    @State private var duration: Double = 0.0
    @State private var currentTime: Double = 0.0
    @State private var endObserver: Any?
    
    var body: some View {
        VStack {
            if let player = player {
                Slider(value: Binding(
                    get: { self.currentTime },
                    set: { newValue in
                        self.currentTime = newValue
                        self.player?.seek(to: CMTime(seconds: newValue, preferredTimescale: 600))
                    }
                ), in: 0...duration)
                
                HStack {
                    Text(formatTime(seconds: currentTime))
                    Spacer()
                    Text(formatTime(seconds: duration))
                }
            }
            
            HStack {
                Button(action: {
                    if player?.timeControlStatus == .playing {
                        player?.pause()
                    } else {
                        player?.play()
                    }
                }) {
                    Image(systemName: player?.timeControlStatus == .playing ? "pause.fill" : "play.fill")
                }
                .font(.largeTitle)
                
                Button(action: {
                    player?.seek(to: CMTime(seconds: 0, preferredTimescale: 600))
                    player?.pause()
                }) {
                    Image(systemName: "stop.fill")
                }
                .font(.largeTitle)
            }
        }
        .padding()
        .onAppear {
            if let audioPath = recordingManager.audioPath {
                let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = appDirectory.appendingPathComponent(recordingManager.recordFilename)
                
                self.playerItem = AVPlayerItem(url: fileURL)
                self.player = AVPlayer(playerItem: playerItem)
                
                self.playerObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
                    self.currentTime = time.seconds
                }
                
                self.duration = playerItem?.asset.duration.seconds ?? 0
                
                // Add observer for end of playback
                self.endObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playerItem, queue: .main) { _ in
                    self.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 600))
                    self.player?.pause()
                    self.currentTime = 0
                }
                
                self.player?.volume = 1.0 // Imposta il volume al massimo
            }
        }
        .onDisappear {
            if let playerObserver = playerObserver {
                player?.removeTimeObserver(playerObserver)
            }
            if let endObserver = endObserver {
                NotificationCenter.default.removeObserver(endObserver)
            }
            player?.pause()
            player = nil
            playerItem = nil
            recordingManager.audioPath?.stopAccessingSecurityScopedResource()
        }
    }
    
    func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func toTime(_ time: Double) {
        self.currentTime = time - 10
        self.player?.seek(to: CMTime(seconds: time - 10, preferredTimescale: 600))
        self.player?.pause()
    }
}

#Preview {
    Player(recordingManager: RecordingManager())
}
