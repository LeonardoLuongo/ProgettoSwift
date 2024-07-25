import SwiftUI

struct RecordPage: View {
    @ObservedObject var recordingManager = RecordingManager()
    @State private var isLoadingFile: Bool = false
    @State private var isLoadingAudio: Bool = false
    @Binding var expositions: [Int:[Exposition]]
    @Binding var exposition: Exposition
    @ObservedObject var evaluator: Evaluator
    
    init(expositions: Binding<[Int:[Exposition]]>, exposition: Binding<Exposition>) {
        self._expositions = expositions
        self._exposition = exposition
        self.evaluator = Evaluator(exposition: exposition, expositions: expositions, evaluationError: .constant(false))
    }
    
    init(recordingManager: RecordingManager, expositions: Binding<[Int:[Exposition]]>, exposition: Binding<Exposition>) {
        self.recordingManager = recordingManager
        self._expositions = expositions
        self._exposition = exposition
        self.evaluator = Evaluator(exposition: exposition, expositions: expositions, evaluationError: .constant(false))
    }

    var body: some View {
        if !exposition.evaluated || !evaluator.completed {
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
                                    defer { fileurl[0].stopAccessingSecurityScopedResource() }
                                    var paths = "\(fileurl[0])".split(separator: "/")
                                    paths.reverse()
                                    paths[0] = "\(paths[0].replacingOccurrences(of: "%20", with: " ").lowercased())"
                                    recordingManager.docFilename = String(paths[0])
                                    recordingManager.docPath =  fileurl[0]
                                    if let docPath = recordingManager.docPath {
                                        print("FilePath: \(docPath)")
                                    }
                                    recordingManager.textLoaded = true
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
                                            }
                                            recordingManager.recorded = true
                                            recordingManager.recLoaded = true
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
                    RecordBar(recordingManager: recordingManager, evaluator: evaluator, expositions: $expositions, exposition: $exposition)
                }
            }
        } else {
            TestFinalPage(exposition: $exposition)
        }
    }
}

#Preview {
    RecordPage(expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "10", secCode: 3)]]), exposition: .constant(Exposition(date: "07-20-2024", grade: "10", secCode: 3)))
}
