import SwiftUI

struct CorrectionCard: View {
    var number: Int = 2
    var mainSentence: Sentence
    var prevSentence: Sentence?
    var nextSentence: Sentence?

    init(number: Int, mainSentence: Sentence, prevSentence: Sentence? = nil, nextSentence: Sentence? = nil) {
        self.number = number
        self.mainSentence = mainSentence
        self.prevSentence = prevSentence
        self.nextSentence = nextSentence
    }

    var body: some View {
        GeometryReader { metrics in
            VStack {
                Spacer()

                HStack {
                    Spacer()
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center) {
                            Spacer()
                            HStack {
                                if let prevSentence = self.prevSentence {
                                    switch prevSentence.getStatus() {
                                    case .warning:
                                        Text("\(prevSentence.getText())")
                                            .foregroundColor(.black)
                                            .padding(.all)
                                            .background(Color.yellow)
                                    case .wrong:
                                        Text("\(prevSentence.getText())")
                                            .foregroundColor(.black)
                                            .padding(.all)
                                            .background(Color.red)
                                    default:
                                        Text("\(prevSentence.getText())")
                                            .foregroundColor(.black)
                                            .padding(.all)
                                    }
                                }

                                switch mainSentence.getStatus() {
                                case .warning:
                                    Text("\(mainSentence.getText())")
                                        .foregroundColor(.black)
                                        .padding(.all)
                                        .background(Color.yellow)
                                case .wrong:
                                    Text("\(mainSentence.getText())")
                                        .foregroundColor(.black)
                                        .padding(.all)
                                        .background(Color.red)
                                default:
                                    Text("\(mainSentence.getText())")
                                        .foregroundColor(.black)
                                        .padding(.all)
                                        .background(Color.gray)
                                }

                                if let nextSentence = self.nextSentence {
                                    switch nextSentence.getStatus() {
                                    case .warning:
                                        Text("\(nextSentence.getText())")
                                            .foregroundColor(.black)
                                            .padding(.all)
                                            .background(Color.yellow)
                                    case .wrong:
                                        Text("\(nextSentence.getText())")
                                            .foregroundColor(.black)
                                            .padding(.all)
                                            .background(Color.red)
                                    default:
                                        Text("\(nextSentence.getText())")
                                            .foregroundColor(.black)
                                            .padding(.all)
                                    }
                                }
                                if let correction = mainSentence.getCorrection() {
                                    Divider()
                                    Text("\(correction)")
                                        .foregroundColor(.black)
                                        .padding(.all)
                                }
                                if let reason = mainSentence.getReason() {
                                    Divider()
                                    Text("\(reason)")
                                        .foregroundColor(.black)
                                        .padding(.all)
                                }
                                Spacer()
                            }
                        }
                        .frame(width: metrics.size.width*0.8, height: metrics.size.height*0.95)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)

                        Spacer()
                    }

                    Spacer()
                }
            }
        }
    }
}

struct CorrectionCard_Previews: PreviewProvider {
    
    static private var mainSentence: Sentence? = initMainSentence()
    static private var prevSentence: Sentence? = initPrevSentence()
    static private var nextSentence: Sentence? = initNextSentence()
    
    static func initMainSentence() -> Sentence? {
        do {
            let sentence = try Sentence(entireText: "Prima frase. Seconda frase. Terza frase. ", sentenceText: "Seconda frase. ", status: .wrong)
            return sentence
        } catch {
            return nil
        }
    }
    
    static func initPrevSentence() -> Sentence? {
        do {
            let sentence = try Sentence(entireText: "Prima frase. Seconda frase. Terza frase. ", sentenceText: "Prima frase. ", status: .wrong)
            return sentence
        } catch {
            return nil
        }
    }
    
    static func initNextSentence() -> Sentence? {
        do {
            let sentence = try Sentence(entireText: "Prima frase. Seconda frase. Terza frase. ", sentenceText: "Terza frase. ", status: .wrong)
            return sentence
        } catch {
            return nil
        }
    }
    
    static var previews: some View {
        CorrectionCard(number: 5, mainSentence: mainSentence!, prevSentence: prevSentence!, nextSentence: nextSentence!)
    }
}
