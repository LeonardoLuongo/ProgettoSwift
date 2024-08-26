
import SwiftUI

class SingleWord: Identifiable, Codable{
    internal var id = UUID()
    private let text: String
    private var sentenceId: UUID?
    
    init(id: UUID = UUID(), text: String, sentenceId: UUID? = nil, timestamp: Double? = nil, isTimestampCaptured:Bool = true) {
        self.id = id
        self.text = text
        self.sentenceId = sentenceId
    }
    
    public func getText() -> String
    {
        return text
    }
    
    public func setSentenceId(_ sentenceId: UUID?)
    {
        self.sentenceId = sentenceId
    }
    
    public static func stringToSingleStrWords(text: String) -> [String]
    {
        let words = text.split(separator: " ")
        var singleStrWords: [String] = []
        for word in words
        {
            singleStrWords.append(String(word))
        }
        if var lastStr = singleStrWords.last
        {
            lastStr.removeLast()
        }
        return singleStrWords
    }
    
    public static func singleWordsToString(
        textInSingleWords: [SingleWord], wordSeparator: String = " "
    ) -> String
    {
        var textInString = ""
        for word in textInSingleWords {
            textInString.append(word.getText() + wordSeparator)
        }

        return textInString
    }
    
    // To Do: Check if the commented code is obsolete
    public static func textToSingleWordArray(text: String) -> [SingleWord]
    {
        let words = text.split(separator: " ")
        var singleWords: [SingleWord] = []
        for word in words
        {
            singleWords.append(SingleWord(text: String(word)))
        }
        
        /*
        if var lastStr = singleWords.last
        {
            singleWords.removeLast()
        }
        */
        
        return singleWords
    }
}


