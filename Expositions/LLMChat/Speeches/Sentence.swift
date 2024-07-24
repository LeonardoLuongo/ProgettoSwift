import SwiftUI

enum SentenceError: Error {
    case runtimeError(String)
}

class Sentence: Identifiable, Codable {
    
    var id = UUID()
    private let text: String
    private let status: SentenceStatus
    private let correction: String?
    private let reason: String?
    private let range: [Int]
    private var words: [SingleWord] = []
    private var index: Int
    
    init(entireText:String, sentenceText: String, status: SentenceStatus, correction: String? = nil, reason: String? = nil, index: Int) throws
    {
        self.text = sentenceText
        self.status = status
        self.correction = correction
        self.reason = reason
        
        if let range = entireText.range(of: sentenceText){
            
            let lowerBoundInt = range.lowerBound.utf16Offset(in: self.text)
            let upperBoundInt = range.upperBound.utf16Offset(in: self.text)
            
            self.range = [lowerBoundInt, upperBoundInt]
        }
        else
        {
            throw SentenceError.runtimeError("The string \"\(text)\" was not found in \"\(self.text)\"")
        }
        
        self.index = index
        let words = self.text.split(separator: " ")
        for word in words
        {
            self.words.append(SingleWord(text: String(word) + " ", sentence: self))
        }
        
        
    }
    
    public func getSingleWords() -> [SingleWord]
    {
        return self.words
    }
    
    public func getRange() -> [Int]
    {
        return self.range
    }
    
    public func getCorrection() -> String?
    {
        return self.correction
    }

    public func getStatus() -> SentenceStatus
    {
        return self.status
    }
    
    public func getText() -> String {
        return self.text
    }
    
}

enum SentenceStatus: Codable {
    case okay, warning, wrong
}

