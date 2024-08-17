import SwiftUI

let DEBUG: Bool = true
func writeDebugLog(_ log: String)
{
    if DEBUG
    {
        print(log)
    }
}
/*
@main
struct HighlightApp: App {
    var body: some Scene {
        WindowGroup {
            LLMChatContentView(context: CONTEXT[INDEX]!, speech: SPEECH[INDEX]!)
        }
    }
}

struct LLMChatContentView: View {
    let context: String
    let speech: String
    
    @State private var evaluatedSpeech: EvaluatedSpeech? = nil
    @State private var status: String = "Loading..."

    
    var body: some View {
        ScrollView {
            if let evaluatedSpeech = evaluatedSpeech {
                let sentences = evaluatedSpeech.getTextInSentences()
                ForEach(sentences)
                {
                    sentence in
                    Text(LLMChatContentView.sentenceToAttributedString(sentence: sentence))
                        .onTapGesture {
                            print("Correction: \(String(describing: sentence.getCorrection()))")
                            print("Reason: \(String(describing: sentence.getReason()))")
                            print("Status: \(sentence.getStatus())")
                        }
                }
            } else {
                Text(status)
            }
        }
        .onAppear {
            Task {
                await loadSpeechEvaluation()
            }
        }
    }

    // Asynchronous function to load speech evaluation
    func loadSpeechEvaluation() async {
        var singleWords: [SingleWord] = []
        
        for word in speech.split(separator: " ") {
            singleWords.append(SingleWord(text: word + " "))
        }
        
        let rawSpeech = RawSpeech(textInSingleWords: singleWords)
        
        do {
            
            status = "From Raw Text to Punctualized..."
            writeDebugLog("From Raw Text to Punctualized...")
            
            let punctualizedSpeech = try await PunctualizedSpeech(rawSpeech: rawSpeech, context: context)
            
            status = "From Punctualized to Evaluated..."
            writeDebugLog("From Punctualized to Evaluated...")
            
            let evaluatedSpeech = try await EvaluatedSpeech(context: context, punctualizedText: punctualizedSpeech)
            
            status = "Evaluation Ended."
            writeDebugLog("Evaluation Ended.")
            
            self.evaluatedSpeech = evaluatedSpeech
            
            var chrsNum = 0
            for sentence in evaluatedSpeech.getTextInSentences() {
                chrsNum += sentence.getText().count
            }
            let v = punctualizedSpeech.getText().count - chrsNum
            print("Punctualized - EvaluatedSpeech: ",
                  v
            )
            
        } catch {
            status = "Error: \(error)"
            print("\(error)")
        }
    }
    
    static func sentenceToAttributedString(sentence: Sentence) -> AttributedString
    {
        var attributedString = AttributedString(sentence.getText())
        
        switch sentence.getStatus() {
        case .okay:
            attributedString.backgroundColor = .green
            break
        case .warning:
            attributedString.backgroundColor = .yellow
            break
        case .wrong:
            attributedString.backgroundColor = .red
            break
        }
        return attributedString
    }
}



#Preview {
    LLMChatContentView(context: CONTEXT[INDEX]!, speech: SPEECH[INDEX]!)
}
*/
