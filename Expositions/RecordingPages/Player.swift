import SwiftUI
import AVFoundation

struct Player: View {
    @ObservedObject var recordingManager: RecordingManager
    @State private var player: AVPlayer?
    @State private var playerItem: AVPlayerItem?
    @State private var playerObserver: Any?
    @State private var duration: Double = 0.0
    @State private var currentTime: Double = 0.0
    
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
            print(recordingManager.audioPath)
            if let audioPath = recordingManager.audioPath {
                let _ = audioPath.startAccessingSecurityScopedResource()
                let fileManager = FileManager.default
                if let audioPath = recordingManager.audioPath {
                    if fileManager.fileExists(atPath: audioPath.path) {
                        print("Il file esiste")
                    } else {
                        print("Il file non esiste")
                    }
                }
                self.playerItem = AVPlayerItem(url: audioPath)
                self.player = AVPlayer(playerItem: playerItem)
                
                self.playerObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
                    self.currentTime = time.seconds
                }
                
                self.duration = playerItem?.asset.duration.seconds ?? 0
            }
        }
        .onDisappear {
            if let playerObserver = playerObserver {
                player?.removeTimeObserver(playerObserver)
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
}

#Preview {
    Player(recordingManager: RecordingManager())
}
