
import SwiftUI

class SingleWord: Identifiable, Codable{
    internal var id = UUID()
    private let text: String
    private var sentenceId: UUID?
    private var timestamp: Double? = nil
    private var isTimestampCaptured: Bool
    
    init(id: UUID = UUID(), text: String, sentenceId: UUID? = nil, timestamp: Double? = nil, isTimestampCaptured:Bool = true) {
        self.id = id
        self.text = text
        self.sentenceId = sentenceId
        self.timestamp = timestamp
        self.isTimestampCaptured = isTimestampCaptured
    }
    
    public func getTimestamp() -> Double?
    {
        return timestamp
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
    
    public static func textToSingleWordArray(text: String) -> [SingleWord]
    {
        let words = text.split(separator: " ")
        var singleWords: [SingleWord] = []
        for word in words
        {
            singleWords.append(SingleWord(text: String(word)))
        }
        
        return singleWords
    }
}


