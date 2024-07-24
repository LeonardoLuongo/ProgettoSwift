import Foundation

class PunctualizedSpeech
{
    internal var id = UUID()
    public let textInString: String
    private let textInSingleWords: [SingleWord]
    
    init(rawSpeech: RawSpeech) {
        // Get the new punctualized text.
        var punctualizedText = LLMUtilis.addPuntuactionToText(rawSpeech.getTextInString())
        
        // From the entire punctualized text to array of words.
        var singleStrWords = SingleWord.stringToSingleStrWords(text: punctualizedText)
        
        // From the entire old not punctualized text to array of words.
        let singleWords = rawSpeech.getTextInSingleWords()
        
        // Container for the new single words punctualized.
        var newSingleWords: [SingleWord] = []
        
        // For every old single word...
        for i in 0...singleWords.count
        {
            // ... create a new single word with,
            // the text of the new punctualized text
            // and the timestamp of the old one.
            newSingleWords.append(
                SingleWord(text: newSingleWords[i].getText(), timestamp: singleWords[i].getTimestamp())
            )
        }
        
        self.textInSingleWords = newSingleWords
        self.textInString = SingleWord.singleWordsToString(textInSingleWords: textInSingleWords)
    }
    
    private static func singleWordsToString(textInSingleWords: [SingleWord]) -> String
    {
        var textInString = ""
        for word in textInSingleWords {
            textInString.append(word.getText())
        }

        return textInString
    }
    
    public func getId() -> UUID
    {
        return self.id
    }
    
    public func getTextInSingleWords() -> [SingleWord]
    {
        return self.textInSingleWords
    }
    
}

