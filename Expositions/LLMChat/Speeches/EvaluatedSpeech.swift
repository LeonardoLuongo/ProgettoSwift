import Foundation

class EvaluatedSpeech
{
    private let text: String
    public let textInSentences: [Sentence]
    private var wrongSentences: [Int: Sentence] = [:]
    private var okaySentences: [Int: Sentence] = [:]
    private var warningSentences: [Int: Sentence] = [:]
    
    init(text: String, textInSentences: [Sentence]) {
        self.text = text
        self.textInSentences = textInSentences
        
        var index: Int = 0
        for sentence in textInSentences {
            if sentence.getStatus() == .okay
            {
                okaySentences.updateValue(sentence, forKey: index)
            }
            else if sentence.getStatus() == .warning
            {
                warningSentences.updateValue(sentence, forKey: index)
            }
            else if sentence.getStatus() == .wrong
            {
                wrongSentences.updateValue(sentence, forKey: index)
            }
            index += 1
        }
        
    }
    
    /*
    init(punctualizedText: PunctualizedSpeech) throws
    {
        var evaluatedText: Response
        
        do
        {
            evaluatedText = try LLMUtilis.evaluate(exposition: punctualizedText.textInString)
        }
        catch
        {
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        
        
        
    }
    */

}

