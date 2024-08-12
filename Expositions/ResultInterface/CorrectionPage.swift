import SwiftUI

struct CorrectionPage: View {
    @ObservedObject var exposition: Exposition
    @State private var currentCardNumber: Int = 1
    var totalCardNumber: Int
    var evaluatedSpeech: EvaluatedSpeech?
    @ObservedObject var recordingManager: RecordingManager
    var grade: String
    @State private var index: Int = 0
    @State private var player: Player?
    @State var cards: [Int: CorrectionCard] = [:]


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
                Spacer()
                    .frame(height: metrics.size.height * 0.1)
                
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
                            .onChange(of: currentCardNumber) { newValue in
                                handleCardChange(newCardNumber: newValue)
                            }
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
                    ForEach(1...totalCardNumber, id: \.self) { index in
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
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: metrics.size.height * 0.75)
                
                //Spacer()
                
                VStack {
                    Player(recordingManager: recordingManager)
                        .onAppear {
                            player = Player(recordingManager: recordingManager)
                        }
                    Spacer()
                        .frame(height: metrics.size.height * 0.1)
                }
                Spacer()
                
            }
            .frame(height: metrics.size.height)
        }
    }
    
    @ViewBuilder
    func createCorrectionCardView(for index: Int) -> some View {
        if let correctionCard = try? createCorrectionCard() {
            correctionCard
        } else {
            GradeCard(number: index, grade: grade)
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
        cards[index] = CorrectionCard(number: index, mainSentence: mainSentence!, prevSentence: prevSentence, nextSentence: nextSentence)
        return cards[index] ?? CorrectionCard(number: index, mainSentence: mainSentence!, prevSentence: prevSentence, nextSentence: nextSentence)
        return CorrectionCard(number: index, mainSentence: mainSentence!, prevSentence: prevSentence, nextSentence: nextSentence)
    }
    
    func handleCardChange(newCardNumber: Int) {
        print(cards[newCardNumber] ?? "non c'è")
        if var time = cards[newCardNumber]?.mainSentence.getSingleWords()[0].getTimestamp() {
            if time < 10 {
                player?.toTime(time)
            } else {
                player?.toTime(time - 10)
            }
        }
        
    }
}

struct CorrectionPagePreview: PreviewProvider {
    static var previews: some View {
        let exposition = Exposition(date: "28-07-2024", grade: "B", secCode: 1)
        CorrectionPage(exposition: exposition, totalCardNumber: 11)
    }
}
