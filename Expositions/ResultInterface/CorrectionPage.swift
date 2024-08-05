import SwiftUI

struct CorrectionPage: View {
    @ObservedObject var exposition: Exposition
    @State private var currentCardNumber: Int = 1
    var totalCardNumber: Int
    var evaluatedSpeech: EvaluatedSpeech?
    @ObservedObject var recordingManager: RecordingManager
    var grade: String
    @State private var index: Int = 0

    init(exposition: Exposition, totalCardNumber: Int) {
        self.exposition = exposition
        self.totalCardNumber = totalCardNumber
        self.evaluatedSpeech = exposition.evaluatedSpeech
        self.recordingManager = exposition.recordingManager
        self.grade = exposition.grade
    }
    
    var body: some View {
        
        GeometryReader { metrics in
            VStack {
                TextField("Record name", text: $recordingManager.recordName)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding()
                    .padding(.bottom, -10)
                    .multilineTextAlignment(.center)
                    .disabled(recordingManager.isRecording)

                HStack {
                    Spacer()

                    Button(action: {
                        if currentCardNumber > 1 {
                            withAnimation {
                                currentCardNumber -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: metrics.size.height * 0.025, height: metrics.size.height * 0.025)
                            .foregroundColor(.black)
                            .opacity(currentCardNumber == 1 ? 0 : 1)
                    }
                    .disabled(currentCardNumber == 1)

                    Spacer()

                    if currentCardNumber == totalCardNumber {
                        Text("Grade")
                            .font(.system(size: metrics.size.height * 0.04))
                    } else {
                        Text("\(currentCardNumber) / \(totalCardNumber - 1)")
                            .font(.system(size: metrics.size.height * 0.04))
                    }

                    Spacer()

                    Button(action: {
                        if currentCardNumber < totalCardNumber {
                            withAnimation {
                                currentCardNumber += 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: metrics.size.height * 0.025, height: metrics.size.height * 0.025)
                            .foregroundColor(.black)
                            .opacity(currentCardNumber == totalCardNumber ? 0 : 1)
                    }
                    .disabled(currentCardNumber == totalCardNumber)

                    Spacer()
                }
                Spacer()

                TabView(selection: $currentCardNumber) {
                    ForEach(1..<totalCardNumber, id: \.self) { index in
                        if index == totalCardNumber {
                            GradeCard(number: index, grade: grade)
                                .tag(index)
                                .frame(height: metrics.size.height * 0.8)
                        } else {
                            createCorrectionCardView(for: index)
                                .tag(index)
                                .frame(height: metrics.size.height * 0.8)
                        }
                    }
                    // Grade page as the last page
                    Text("Grade")
                        .tag(totalCardNumber)
                        .frame(height: metrics.size.height * 0.8)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: metrics.size.height * 0.75)
                
                Spacer()
                
                VStack {
                    Player(recordingManager: RecordingManager())
                    Spacer()
                }
                
            }
        }
    }
    
    @ViewBuilder
    func createCorrectionCardView(for index: Int) -> some View {
        if let correctionCard = try? createCorrectionCard() {
            correctionCard
        } else {
            GradeCard(number: index, grade: "")
        }
    }

    func createCorrectionCard() throws -> CorrectionCard {
        let sentences = evaluatedSpeech?.getTextInSentences()
        
        let mainSentence: Sentence?
        let prevSentence: Sentence?
        let nextSentence: Sentence?
        
        while sentences?[index].getStatus() == .okay { index += 1 }
        
        mainSentence = sentences?[index]
        if index != 0 {
            prevSentence = sentences?[index - 1]
        } else {
            prevSentence = nil
        }
        if index != sentences?.count {
            nextSentence = sentences?[index + 1]
        } else {
            nextSentence = nil
        }
        return CorrectionCard(number: index, mainSentence: mainSentence!, prevSentence: prevSentence, nextSentence: nextSentence)
        
    }
}

struct CorrectionPagePreview: PreviewProvider {
    static var previews: some View {
        let exposition = Exposition(date: "28-07-2024", grade: "B", secCode: 1)
        CorrectionPage(exposition: exposition, totalCardNumber: 11)
    }
}
