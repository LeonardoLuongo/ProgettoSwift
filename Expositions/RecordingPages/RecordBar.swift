//
//  RecordBar.swift
//  RecordingPages
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct RecordBar: View {
    @ObservedObject var recordingManager: RecordingManager
    @ObservedObject var evaluator: Evaluator
    
    @Binding var expositions: [Int:[Exposition]]
    @Binding var exposition: Exposition
    
    
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
                if recordingManager.recorded && evaluator.progress < 0 {
                    Button(action: {
                        // Aggiungi azione per "Evaluate"
                        evaluator.evaluate()
                    }) {
                        /*  The evalueate button will be usable (and colorful) only if both the doc and the rec have been loaded */
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
                } else if evaluator.progress < 0 {
                    /* If there is no audio yet, the bottom bar will display the record button... */
                    Button(action: {
                        if !recordingManager.recordPermissionGranted {
                            recordingManager.errorMessage = "Record permission denied! Grant permission in settings."
                            recordingManager.showErrorAlert = true
                            return
                        }
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
                } else {
                    // Mostra la ProgressView quando il bottone viene premuto
                    VStack {
                        Text("Evaluating...")
                            .foregroundStyle(.black)
                        ProgressView(value: evaluator.progress)
                            .progressViewStyle(CustomLinearProgressViewStyle(trackColor: .gray, progressColor: Color(hue: 0.58, saturation: 0.63, brightness: 0.96)))
                        Text(evaluator.progress.formatted(.percent.precision(.fractionLength(0))))
                            .foregroundStyle(.black)
                        Button(action: {
                            evaluator.stopTask()
                        }) {
                            VStack {
                                Text("Stop")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 125, height: 50)
                            .background(.red)
                            .cornerRadius(15)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                        }
                    }
                    .padding([.bottom, .leading, .trailing])
                }
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background(Color(hue: 0, saturation: 0, brightness: 0.95))
        }
    }
}

struct CustomLinearProgressViewStyle: ProgressViewStyle {
    var trackColor: Color
    var progressColor: Color

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(trackColor)
                    .opacity(0.5)
                Rectangle()
                    .foregroundColor(progressColor)
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
            }
            .cornerRadius(10.0)
        }
        .frame(height: 10)
    }
}

#Preview {
    RecordBar(recordingManager: RecordingManager(), evaluator: Evaluator(exposition: .constant(Exposition(date: "07-20-2024", grade: "10", secCode: 3)), expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "10", secCode: 3)]]), evaluationError: .constant(false)), expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "10", secCode: 3)]]), exposition: .constant(Exposition(date: "07-20-2024", grade: "10", secCode: 3)))
}
