//
//  Stopwatch.swift
//  RecordingPages
//
//  Created by Studente on 12/07/24.
//

import SwiftUI
import Combine

struct Stopwatch: View {
    @ObservedObject var recordingManager: RecordingManager
    
    /// Current progress time expressed in seconds
    @State private var progressTime: Int
    @State private var isRunning = false
    @State private var timer: Timer?

    init(startTime progressTime: Int = 0, recordingManager: RecordingManager) {
        self.recordingManager = recordingManager
        self.progressTime = progressTime
    }

    /// Computed properties to get the progressTime in hh:mm:ss format
    var hours: Int {
        progressTime / 3600
    }

    var minutes: Int {
        (progressTime % 3600) / 60
    }

    var seconds: Int {
        progressTime % 60
    }

    var body: some View {
        HStack(spacing: 10) {
            if (progressTime >= 3600) {
                StopwatchUnit(timeUnit: hours)
                Text(":")
                    .font(.system(size: 48))
                    .offset(y: -5)
            }
            StopwatchUnit(timeUnit: minutes)
            Text(":")
                .font(.system(size: 48))
                .offset(y: -5)
            StopwatchUnit(timeUnit: seconds)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            saveTimer()
            stopTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            progressTime += 1
        }
    }
    
    func saveTimer() {
        recordingManager.duration.hours = self.hours
        recordingManager.duration.minutes = self.minutes
        recordingManager.duration.seconds = self.seconds
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
}

struct StopwatchUnit: View {
    var timeUnit: Int

    var timeUnitStr: String {
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }

    var body: some View {
        HStack(spacing: 2) {
            Text(timeUnitStr.substring(index: 0))
                .font(.system(size: 48))
                .frame(width: 28)
            Text(timeUnitStr.substring(index: 1))
                .font(.system(size: 48))
                .frame(width: 28)
        }
    }
}

struct Stopwatch_Previews: PreviewProvider {
    static var previews: some View {
        Stopwatch(recordingManager: RecordingManager())
    }
}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}




struct StopwatchFinal: View {
    @ObservedObject var recordingManager: RecordingManager
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    init(recordingManager: RecordingManager) {
        self.recordingManager = recordingManager
        self.hours = recordingManager.duration.hours
        self.minutes = recordingManager.duration.minutes
        self.seconds = recordingManager.duration.seconds
    }
    

    var body: some View {
        HStack(spacing: 10) {
            if (hours > 0) {
                StopwatchUnit(timeUnit: hours)
                Text(":")
                    .font(.system(size: 48))
                    .offset(y: -5)
            }
            StopwatchUnit(timeUnit: minutes)
            Text(":")
                .font(.system(size: 48))
                .offset(y: -5)
            StopwatchUnit(timeUnit: seconds)
        }
    }
}
