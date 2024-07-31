import SwiftUI

struct CorrectionPage: View {
    @ObservedObject var exposition: Exposition
    @State private var currentCardNumber: Int = 1
    var totalCardNumber: Int

    var body: some View {
        GeometryReader { metrics in
            VStack {
                TextField("Record name", text: $exposition.recordingManager.recordName)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding()
                    .padding(.bottom, -10)
                    .multilineTextAlignment(.center)
                    .disabled(exposition.recordingManager.isRecording)
                
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
                        Text("\(currentCardNumber) / \(totalCardNumber)")
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
                    ForEach(1...totalCardNumber, id: \.self) { index in
                        if index == totalCardNumber {
                            GradeCard(number: index, grade: exposition.grade)
                                .tag(index)
                                .frame(height: metrics.size.height * 0.8)
                        } else {
                            var mainSentence = Sentence(entireText: "Prima frase. Seconda frase. Terza frase. ", sentenceText: "Seconda frase. ", status: .wrong, index: 1)
                            var prevSentence = Sentence(entireText: "Prima frase. Seconda frase. Terza frase. ", sentenceText: "Prima frase. ", status: .wrong, index: 0)
                            var nextSentence = Sentence(entireText: "Prima frase. Seconda frase. Terza frase. ", sentenceText: "Terza frase. ", status: .wrong, index: 2)
                            CorrectionCard(number: index, mainSentence: mainSentence, prevSentence: prevSentence, nextSentence: nextSentence)
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
                .frame(height: metrics.size.height * 0.8)
                
                Spacer()
                
                Player(recordingManager: RecordingManager())
            }
        }
    }
}

#Preview {
    var exposition = Exposition(date: "28-07-2024", grade: "B", secCode: 1)
    CorrectionPage(exposition: exposition, totalCardNumber: 11)
}
