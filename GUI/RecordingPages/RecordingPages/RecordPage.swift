//
//  RecordPage.swift
//  RecordingPages
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct RecordPage: View {
    @StateObject var recordingManager = RecordingManager()
    @State private var isLoadingFile: Bool = false
    @State private var isLoadingAudio: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                
                TextField("Record name", text: $recordingManager.recordName)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding()
                    .multilineTextAlignment(.center)
                    .disabled(recordingManager.isRecording)
                
                Spacer()
                
                Button(action: {
                    isLoadingFile = true
                }) {
                    if recordingManager.textLoaded {
                        VStack {
                            Text(recordingManager.docName)
                                .frame(height: 125)
                                .font(.system(size: 20))
                                .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                        }
                        .frame(width: 350, height: 225)
                        .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                        .cornerRadius(15)
                    } else {
                        VStack {
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                        }
                        .frame(width: 350, height: 225)
                        .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                        .cornerRadius(15)
                    }
                }
                .disabled(recordingManager.isRecording)
                .fileImporter(isPresented: $isLoadingFile, allowedContentTypes: [.pdf, .plainText, .rtf, .spreadsheet, .presentation], allowsMultipleSelection: false, onCompletion: { results in
                    
                    switch results {
                    case .success(let fileurl):
                        recordingManager.docPath = fileurl[0]
                        var paths = "\(fileurl[0])".split(separator: "/")
                        paths.reverse()
                        recordingManager.docName = String(paths[0])
                        recordingManager.textLoaded = true
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                })
                
                Spacer()
                
                Button(action: {
                    isLoadingAudio = true
                }) {
                    if recordingManager.recorded {
                        VStack {
                            StopwatchFinal(recordingManager: recordingManager)
                                .frame(height: 125)
                                .font(.system(size: 20))
                                .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                        }
                        .frame(width: 350, height: 225)
                        .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                        .cornerRadius(15)
                    } else {
                        VStack {
                            Image(systemName: "waveform.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                        }
                        .frame(width: 350, height: 225)
                        .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                        .cornerRadius(15)
                    }
                }
                .disabled(recordingManager.isRecording || recordingManager.recorded)
                .fileImporter(isPresented: $isLoadingAudio, allowedContentTypes: [.audio, .mp3, .wav, .mpeg4Audio], allowsMultipleSelection: false, onCompletion: { results in
                    
                    switch results {
                    case .success(let fileurls):
                        print(fileurls.count)
                        
                        for fileurl in fileurls {
                            print(fileurl.path)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                })
                
                Spacer()
                    .frame(height: 120)
                
            }
            .alert(isPresented: $recordingManager.showErrorAlert) {
                Alert(
                    title: Text("Attention!"),
                    message: Text(recordingManager.errorMessage),
                    dismissButton: .default(Text("OK")) {
                        recordingManager.showErrorAlert = false
                        recordingManager.isRecording = false
                    }
                )
            }
            
            RecordBar(recordingManager: recordingManager)
        }
    }
}

#Preview {
    RecordPage()
}
