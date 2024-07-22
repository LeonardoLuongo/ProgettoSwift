import SwiftUI

struct RecordPage: View {
    @StateObject var recordingManager = RecordingManager()
    @State private var isLoadingFile: Bool = false
    @State private var isLoadingAudio: Bool = false
    @Binding var expositions: [Int:[Exposition]]
    @Binding var exposition: Exposition
    
    var body: some View {
        GeometryReader { metrics in     //used to obtain the dimensions of the container
            ZStack {
                VStack {
                    
                    /*  You can rename the page, but if you let the textfield empty
                        the page will be identified by the date and time it was created */
                    TextField("Record name", text: $recordingManager.recordName)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding()
                        .multilineTextAlignment(.center)
                        .disabled(recordingManager.isRecording)
                    
                    Spacer()
                    
                    /*  This button allows to load the text file used to controll the accuracy
                        of the exposition recorded/loaded by the user.*/
                    Button(action: {
                        isLoadingFile = true
                    }) {
                        /*  If the decument has been loaded the button will display the filename... */
                        if recordingManager.textLoaded {
                            VStack {
                                Text(recordingManager.docFilename)
                                    .frame(height: 125)
                                    .font(.system(size: metrics.size.height*0.03))
                                    .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                            }
                            .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                            .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                            .cornerRadius(15)
                        /*  ... otherwise it will display an icon   */
                        } else {
                            VStack {
                                Image(systemName: "doc.badge.plus")
                                    .font(.system(size: metrics.size.height*0.06))
                                    .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                            }
                            .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                            .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                            .cornerRadius(15)
                        }
                    }
                    .disabled(recordingManager.isRecording) // The button is disabled if the user is recording
                    .fileImporter(isPresented: $isLoadingFile, allowedContentTypes: [.pdf, .plainText, .rtf, .spreadsheet, .presentation], allowsMultipleSelection: false, onCompletion: { results in
                        /*  The doc name is obtained from the end of the path returned by the file importer */
                        switch results {
                        case .success(let fileurl):
                            if fileurl[0].startAccessingSecurityScopedResource() {
                                var paths = "\(fileurl[0])".split(separator: "/")
                                paths.reverse()
                                paths[0] = "\(paths[0].replacingOccurrences(of: "%20", with: " ").lowercased())"
                                recordingManager.docFilename = String(paths[0])
                                recordingManager.docPath =  fileurl[0]
                                if let docPath = recordingManager.docPath {
                                    print("FilePath: \(docPath)")
                                }
                                recordingManager.textLoaded = true
                                fileurl[0].stopAccessingSecurityScopedResource()
                                Exposition.saveDictionary(expositions: expositions)
                            }
                        case .failure(let error):
                            print(error)
                        }
                        isLoadingFile = false
                        
                    })
                    
                    Spacer()
                    
                    /*  This button allows to load the audio file containing
                        the exposition previously recorded by the user. */
                    Button(action: {
                        isLoadingAudio = true
                    }) {
                        if recordingManager.recorded {
                            /*  If the audio has been loaded the button will display the filename...    */
                            if recordingManager.recLoaded {
                                VStack {
                                    Text(recordingManager.recordFilename)
                                        //.frame(height: 125)
                                        .font(.system(size: metrics.size.height*0.03))
                                        .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                                    Player(recordingManager: recordingManager)
                                }
                                .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                                .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                                .cornerRadius(15)
                            /*  If the audio has been recorded the button will display the duration...  */
                            } else {
                                VStack {
                                    Player(recordingManager: recordingManager)
                                }
                                .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                                .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                                .cornerRadius(15)
                            }
                        /*  ... otherwise it will display an icon   */
                    } else {
                            VStack {
                                Image(systemName: "waveform.badge.plus")
                                    .font(.system(size: metrics.size.height*0.06))
                                    .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                            }
                            .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                            .background(Color(hue: 0, saturation: 0, brightness: 0.95))
                            .cornerRadius(15)
                            .fileImporter(isPresented: $isLoadingAudio, allowedContentTypes: [.audio, .mp3, .wav, .mpeg4Audio], allowsMultipleSelection: false, onCompletion: { results in
                                    switch results {
                                    case .success(let fileurl):
                                        if fileurl[0].startAccessingSecurityScopedResource() {
                                            defer { fileurl[0].stopAccessingSecurityScopedResource() }
                                            var paths = "\(fileurl[0])".split(separator: "/")
                                            paths.reverse()
                                            paths[0] = "\(paths[0].replacingOccurrences(of: "%20", with: " ").lowercased())"
                                            recordingManager.recordFilename = String(paths[0])
                                            recordingManager.audioPath =  fileurl[0]
                                            if let audioPath = recordingManager.audioPath {
                                                print("FilePath: \(audioPath)")
                                                recordingManager.requestTranscribePermissions()
                                                recordingManager.transcribeAudio(url: audioPath)
                                            }
                                            recordingManager.recorded = true
                                            recordingManager.recLoaded = true
                                            fileurl[0].stopAccessingSecurityScopedResource()
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                isLoadingAudio = false
                                })
                        }
                    }
                    /*  The button is disabled if the user is recording or if an audio has already been recorded/loaded */
                    .disabled(recordingManager.isRecording)
                    
                    Spacer()
                    Spacer()
                        .frame(height: 90)
                    
                }
                /*  This alert inform the user that something went wrong. It could be the presence, for some unexplicable error, of two recording manager with the same timestamp */
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
                
                /*  The bottom recording bar */
                RecordBar(recordingManager: recordingManager, expositions: $expositions, exposition: $exposition)
            }
        }
    }
}

#Preview {
    RecordPage(expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "10", secCode: 3)]]), exposition: .constant(Exposition(date: "07-20-2024", grade: "10", secCode: 3)))
}
