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

                HStack {
                    Spacer()
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center) {
                            Spacer()
                            
                            // shows a different header according to the main sencence status
                            switch mainSentence.getStatus() {
                            case .warning:
                                Text("Warning")
                                    .foregroundStyle(Color.primary)
                                    .font(.title)
                                    .padding(.top)
                            case .wrong:
                                Text("Error")
                                    .foregroundStyle(Color.primary)
                                    .font(.title)
                                    .padding(.top)
                            default:
                                Text("Sentence")
                                    .foregroundStyle(Color.primary)
                                    .font(.title)
                                    .padding(.top)
                            }
                            
                            // shows the text with the ain sentence properly highlighted according to its status
                            Text(self.combinedAttributedText())
                                .foregroundStyle(Color.primary)
                                .padding(.all)

                            // if there is a correction display it preceded by a divider
                            if let correction = mainSentence.getCorrection() {
                                Rectangle()
                                    .frame(width: metrics.size.width * 0.7, height: 2)
                                    .cornerRadius(100)
                                    .foregroundStyle(Color.primary)
                                    .padding(.vertical)
                                
                                Text("Correction")
                                    .foregroundColor(Color.primary)
                                    .font(.title)
                                
                                Text("\(correction)")
                                    .foregroundStyle(Color.primary)
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                            }
                            
                            // if there is a reason display it preceded by a divider
                            if let reason = mainSentence.getReason() {
                                Rectangle()
                                    .frame(width: metrics.size.width * 0.7, height: 2)
                                    .cornerRadius(100)
                                    .foregroundStyle(Color.primary)
                                    .padding(.vertical)
                                
                                Text("Reason")
                                    .foregroundStyle(Color.primary)
                                    .font(.title)
                                
                                Text("\(reason)")
                                    .foregroundStyle(Color.primary)
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                            }
                            
                            Spacer().frame(height: metrics.size.height * 0.4)
                        }

                        Spacer()
                    }
                    .frame(width: metrics.size.width * 0.8, height: metrics.size.height * 0.85)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 10, y: 15.0)

                    Spacer()
                }
                .padding(.top, 20)
                .background(Color.black.opacity(0.0))
                Spacer()
            }
        }
    }
    
    // assemble the previous, main and next sentences highlighting the main one according to its status
    func combinedAttributedText() -> AttributedString {
        var attributedString = AttributedString()
            
        if let prevSentence = self.prevSentence {
            let prevAttributedString = AttributedString(prevSentence.toString())
            attributedString += prevAttributedString + AttributedString(" ")
        }
            
        var mainAttributedString = AttributedString(mainSentence.toString())
        switch mainSentence.getStatus() {
        case .warning:
            mainAttributedString.backgroundColor = .yellow
            mainAttributedString.foregroundColor = .black
        case .wrong:
            mainAttributedString.backgroundColor = .red
        default:
            mainAttributedString.font = .headline
        }
        attributedString += mainAttributedString + AttributedString(" ")
        
        if let nextSentence = self.nextSentence {
            let nextAttributedString = AttributedString(nextSentence.toString())
            attributedString += nextAttributedString
        }
        
        return attributedString
    }
}

struct CorrectionCard_Previews: PreviewProvider {

    static private var mainSentence: Sentence? = initMainSentence()
    static private var prevSentence: Sentence? = initPrevSentence()
    static private var nextSentence: Sentence? = initNextSentence()

    static func initMainSentence() -> Sentence? {
        do {
            let sentence = try Sentence(entireText: "Frase precedente a quella d'interesse, che serve solo a dare contesto, quindi cerco di allungarla per testare la scrollview scrivendo ancora ancora e ancora, solo che non ho più idee. Frase principale da correggere, cerco di scriverla più lunga ma ancora non basta. Quindi continuo ancora a scrivere questa frase, solo che non so cosa scrivere, perché non ho un contesto. Mentre questa è la frase successiva, che serve a sua voltab a dare contesto, e cerco di allungare anche questa per provare, ma non troppo.", sentenceText: "Frase principale da correggere, cerco di scriverla più lunga ma ancora non basta. Quindi continuo ancora a scrivere questa frase, solo che non so cosa scrivere, perché non ho un contesto.", status: .okay, correction: "Questa è la correzione. Bla bla bla, hai sbagliato, e invece dovresti dire così. Allungo un po' il brodo per scrivere altre parole e testare la scrollview. Forse mi conviene allungare un altro po'. Devo scoprire come rendere i Divider più visibili ma lasciare un po' di padding a lato.", reason: "La ragione è che dovevo testare. Quindi scrivo qualcosa ancora sempre per testare e vedere la card che scrolla.")
            return sentence
        } catch {
            return nil
        }
    }

    static func initPrevSentence() -> Sentence? {
        do {
            let sentence = try Sentence(entireText: "Frase precedente a quella d'interesse, che serve solo a dare contesto, quindi cerco di allungarla per testare la scrollview scrivendo ancora ancora e ancora, solo che non ho più idee. Frase principale da correggere, cerco di scriverla più lunga ma ancora non basta. Quindi continuo ancora a scrivere questa frase, solo che non so cosa scrivere, perché non ho un contesto. Mentre questa è la frase successiva, che serve a sua voltab a dare contesto, e cerco di allungare anche questa per provare, ma non troppo.", sentenceText: "Frase precedente a quella d'interesse, che serve solo a dare contesto, quindi cerco di allungarla per testare la scrollview scrivendo ancora ancora e ancora, solo che non ho più idee.", status: .okay)
            return sentence
        } catch {
            return nil
        }
    }

    static func initNextSentence() -> Sentence? {
        do {
            let sentence = try Sentence(entireText: "Frase precedente a quella d'interesse, che serve solo a dare contesto, quindi cerco di allungarla per testare la scrollview scrivendo ancora ancora e ancora, solo che non ho più idee. Frase principale da correggere, cerco di scriverla più lunga ma ancora non basta. Quindi continuo ancora a scrivere questa frase, solo che non so cosa scrivere, perché non ho un contesto. Mentre questa è la frase successiva, che serve a sua voltab a dare contesto, e cerco di allungare anche questa per provare, ma non troppo.", sentenceText: "Mentre questa è la frase successiva, che serve a sua voltab a dare contesto, e cerco di allungare anche questa per provare, ma non troppo.", status: .warning)
            return sentence
        } catch {
            return nil
        }
    }

    static var previews: some View {
        CorrectionCard(number: 5, mainSentence: mainSentence!, prevSentence: prevSentence!, nextSentence: nextSentence!)
    }
}
