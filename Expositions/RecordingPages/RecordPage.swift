import SwiftUI

struct RecordPage: View {
    @ObservedObject var recordingManager: RecordingManager
    @State private var isLoadingFile: Bool = false
    @State private var isLoadingAudio: Bool = false
    @Binding var expositions: [Int:[Exposition]]
    @Binding var exposition: Exposition
    @ObservedObject var evaluator: Evaluator
    
    @Binding var refreshID: UUID
    
    init(exposition: Binding<Exposition>, expositions: Binding<[Int:[Exposition]]>, refreshID: Binding<UUID>) {
        self._recordingManager = ObservedObject(wrappedValue: exposition.wrappedValue.recordingManager)
        self._expositions = expositions
        self._exposition = exposition
        self.evaluator = Evaluator(exposition: exposition, expositions: expositions, evaluationError: .constant(false))
        self._refreshID = refreshID
    }
    
    init(recordingManager: RecordingManager, expositions: Binding<[Int:[Exposition]]>, exposition: Binding<Exposition>, refreshID: Binding<UUID>) {
        self.recordingManager = recordingManager
        self._expositions = expositions
        self._exposition = exposition
        self.evaluator = Evaluator(exposition: exposition, expositions: expositions, evaluationError: .constant(false))
        self._refreshID = refreshID
    }
    
    var body: some View {
        if !exposition.evaluated {
            if !evaluator.completed {
                GeometryReader { metrics in     //used to obtain the dimensions of the container
                    ZStack {
                        VStack {
                            /*  You can rename the page, but if you let the textfield empty
                             the page will be identified by the date and time it was created */
                            HStack {
                                Spacer()
                                
                                TextField("Record name", text: $recordingManager.recordName)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .disabled(recordingManager.isRecording)
                                    .onSubmit {
                                        refreshID = UUID()
                                        Exposition.saveDictionary(expositions: expositions)
                                    }
                                
                                Spacer()
                            }
                            
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
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(15)
                                    .contextMenu(ContextMenu(menuItems: {
                                        Button(action: {
                                            recordingManager.docFilename = ""
                                            recordingManager.textLoaded = false
                                            Exposition.saveDictionary(expositions: expositions)
                                        }, label: {
                                            HStack {
                                                Image(systemName: "trash.fill")
                                                Text("Delete")
                                            }
                                        })
                                    }))
                                    /*  ... otherwise it will display an icon   */
                                } else {
                                    VStack {
                                        Image(systemName: "doc.badge.plus")
                                            .font(.system(size: metrics.size.height*0.06))
                                            .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                                    }
                                    .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(15)
                                }
                            }
                            .disabled(recordingManager.isRecording || evaluator.progress >= 0) // The button is disabled if the user is recording
                            .fileImporter(isPresented: $isLoadingFile, allowedContentTypes: [.pdf], allowsMultipleSelection: false, onCompletion: { results in
                                /*  The doc name is obtained from the end of the path returned by the file importer */
                                switch results {
                                case .success(let fileurl):
                                    if fileurl[0].startAccessingSecurityScopedResource() {
                                        defer { fileurl[0].stopAccessingSecurityScopedResource() }
                                        var paths = "\(fileurl[0])".split(separator: "/")
                                        paths.reverse()
                                        paths[0] = "\(paths[0].replacingOccurrences(of: "%20", with: " ").lowercased())"
                                        recordingManager.docFilename = String(paths[0])
                                        
                                        // Copia il file nella directory dell'app
                                        let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                        let destinationURL = appDirectory.appendingPathComponent(recordingManager.docFilename)
                                        do {
                                            try FileManager.default.copyItem(at: fileurl[0], to: destinationURL)
                                        } catch {
                                            print("Errore nella copia del file: \(error)")
                                        }
                                        
                                        recordingManager.docPath = destinationURL
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
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(15)
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button(action: {
                                                recordingManager.recordFilename = ""
                                                recordingManager.recorded = false
                                                recordingManager.recLoaded = false
                                                Exposition.saveDictionary(expositions: expositions)
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "trash.fill")
                                                    Text("Delete")
                                                }
                                            })
                                        }))
                                        /*  If the audio has been recorded the button will display the duration...  */
                                    } else {
                                        VStack {
                                            Player(recordingManager: recordingManager)
                                        }
                                        .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(15)
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button(action: {
                                                recordingManager.recordFilename = ""
                                                recordingManager.recorded = false
                                                recordingManager.recLoaded = false
                                                recordingManager.deleteRecordedAudio()
                                                Exposition.saveDictionary(expositions: expositions)
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "trash.fill")
                                                    Text("Delete")
                                                }
                                            })
                                        }))
                                    }
                                    /*  ... otherwise it will display an icon   */
                                } else {
                                    VStack {
                                        Image(systemName: "waveform.badge.plus")
                                            .font(.system(size: metrics.size.height*0.06))
                                            .foregroundColor(Color(hue: 0.58, saturation: 0.63, brightness: 0.96))
                                    }
                                    .frame(width: metrics.size.width*0.9, height: metrics.size.height*0.3)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(15)
                                }
                            }
                            /*  The button is disabled if the user is recording or if an audio has already been recorded/loaded */
                            .disabled(recordingManager.isRecording || evaluator.progress >= 0)
                            .fileImporter(isPresented: $isLoadingAudio, allowedContentTypes: [.audio, .mp3, .wav, .mpeg4Audio], allowsMultipleSelection: false, onCompletion: { results in
                                switch results {
                                case .success(let fileurl):
                                    if fileurl[0].startAccessingSecurityScopedResource() {
                                        defer { fileurl[0].stopAccessingSecurityScopedResource() }
                                        var paths = "\(fileurl[0])".split(separator: "/")
                                        paths.reverse()
                                        paths[0] = "\(paths[0].replacingOccurrences(of: "%20", with: " ").lowercased())"
                                        recordingManager.recordFilename = String(paths[0])
                                        
                                        // Copia il file nella directory dell'app
                                        let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                        let destinationURL = appDirectory.appendingPathComponent(recordingManager.recordFilename)
                                        do {
                                            try FileManager.default.copyItem(at: fileurl[0], to: destinationURL)
                                        } catch {
                                            print("Errore nella copia del file: \(error)")
                                        }
                                        
                                        recordingManager.audioPath = destinationURL
                                        if let audioPath = recordingManager.audioPath {
                                            print("FilePath: \(audioPath)")
                                        }
                                        recordingManager.recorded = true
                                        recordingManager.recLoaded = true
                                        Exposition.saveDictionary(expositions: expositions)
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                                isLoadingAudio = false
                            })
                            
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
                }.onAppear {
                    if !recordingManager.recordPermissionGranted {
                        recordingManager.requestRecordPermission()
                    }
                }
                .navigationBarBackButtonHidden(evaluator.progress >= 0)
            }
        } else {
            CorrectionPage(exposition: exposition, totalCardNumber: (exposition.evaluatedSpeech?.numberOfBadSentences())! + 1)
                .onAppear {
                    refreshID = UUID()
                }
        }
    }
}

#Preview {
    RecordPage(exposition: .constant(Exposition(date: "07-20-2024", grade: "10", secCode: 3)), expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "10", secCode: 3)]]), refreshID: .constant(UUID()))
}
