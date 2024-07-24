import SwiftUI

class SingleWord: Identifiable, Codable{
    internal var id = UUID()
    private let text: String
    private let sentence: Sentence?
    private var timestamp: Double? = nil // THIS IS JUST FOR TESTING PURPOSE, WE ARE NOT INTERESTED YET IN TIMESTAMP
    
    init(id: UUID = UUID(), text: String, sentence: Sentence? = nil, timestamp: Double? = nil) {
        self.id = id
        self.text = text
        self.sentence = sentence
        self.timestamp = timestamp
    }
    
    public func getTimestamp() -> Double?
    {
        return timestamp
    }
    
    public func getText() -> String
    {
        return text
    }
    
    public static func stringToSingleStrWords(text: String) -> [String]
    {
        let words = text.split(separator: " ")
        var singleStrWords: [String] = []
        for word in words
        {
            singleStrWords.append(String(word) + " ")
        }
        if var lastStr = singleStrWords.last
        {
            lastStr.removeLast()
        }
        return singleStrWords
    }
    
    public static func singleWordsToString(textInSingleWords: [SingleWord]) -> String
    {
        var textInString = ""
        for word in textInSingleWords {
            textInString.append(word.getText())
        }

        return textInString
    }
    
}


