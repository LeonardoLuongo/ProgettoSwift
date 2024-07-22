//
//  RecordBar.swift
//  RecordingPages
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct RecordBar: View {
    @ObservedObject var recordingManager: RecordingManager
    
    @Binding var expositions: [Int:[Exposition]]

    var body: some View {
        VStack {
            Spacer()
            VStack {
                /*  If an audio is being recorded here will be visualized the duration of the record */
                if recordingManager.isRecording {
                    Stopwatch(startTime: 0, recordingManager: recordingManager)
                        .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                }
                /*  If an audio has already been recorded the bottom bar will display the evaluate button*/
                if recordingManager.recorded {
                    Button(action: {
                        // Aggiungi azione per "Evaluate"
                    }) {
                        /*  The evalueate button will be usable (and colorful) only if bopth the doc and the red have been loaded */
                        if recordingManager.textLoaded && recordingManager.recorded {
                            VStack {
                                Text("Evaluate")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 125, height: 50)
                            .background(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                            .cornerRadius(15)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                        } else {
                            VStack {
                                Text("Evaluate")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 125, height: 50)
                            .background(Color(hue: 0, saturation: 0, brightness: 0.75))
                            .cornerRadius(15)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                        }
                    }
                    .disabled(!(recordingManager.textLoaded && recordingManager.recorded))
                } else {
                    /* If there is no audio yet, the bottom bar will display the record button... */
                    Button(action: {
                        if recordingManager.isRecording {
                            recordingManager.finishRecordingHandler()
                        } else {
                            recordingManager.startRecording()
                        }
                    }) {
                        /*  ... to finish recording... */
                        if recordingManager.isRecording {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.red)
                                .frame(width: 45, height: 45)
                                .padding(.all, 15)
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 3)
                                )
                        /*  ... or to start recording */
                        } else {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 65, height: 65)
                                .padding(.all, 4)
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 3)
                                )
                        }
                    }
                    /*  This alert allows to save or discard an audio recorded on the moment*/
                    .alert(isPresented: $recordingManager.showAlert) {
                        Alert(
                            title: Text("Save or cancel the record"),
                            message: Text("The operation is irreversible."),
                            primaryButton: .default(Text("Save")) {
                                recordingManager.finishRecording(success: true)
                                print(recordingManager.duration)
                                print(recordingManager.audioPath)
                                print(recordingManager.recorded)
                                Exposition.saveDictionary(expositions: expositions)
                            },
                            secondaryButton: .cancel(Text("Cancel")) {
                                recordingManager.finishRecording(success: false)
                                recordingManager.deleteRecordedAudio()
                            }
                        )
                    }
                }
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background(Color(hue: 0, saturation: 0, brightness: 0.95))
        }
    }
}

#Preview {
    RecordBar(recordingManager: RecordingManager(), expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "10", secCode: 3)]]))
}
