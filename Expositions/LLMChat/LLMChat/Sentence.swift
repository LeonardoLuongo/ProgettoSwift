import SwiftUI

enum SentenceError: Error {
    case runtimeError(String)
}

class Sentence: Identifiable, Codable {
    
    var id = UUID()
    private let status: SentenceStatus
    private let correction: String?
    private let reason: String?
    private let range: [Int]
    private var words: [SingleWord] = []
    
    init(entireText: String, words: [SingleWord], status: SentenceStatus, correction: String? = nil, reason: String? = nil, range:Range<String.Index>? = nil) throws
    {
        self.words = words
        
        self.status = status
        self.correction = correction
        self.reason = reason
        
        var sentenceText: String = ""
        for word in words
        {
            word.setSentenceId(self.id)
            sentenceText.append(word.getText() + " ")
        }
        
        if let _range = range{
            self.range = [
                _range.lowerBound.utf16Offset(in: entireText),
                _range.upperBound.utf16Offset(in: entireText)
            ]
        }
        else
        {
            if let range = entireText.range(of: sentenceText){
                
                let lowerBoundInt = range.lowerBound.utf16Offset(in: entireText)
                let upperBoundInt = range.upperBound.utf16Offset(in: entireText)
                
                self.range = [lowerBoundInt, upperBoundInt]
            }
            else
            {
                throw SentenceError.runtimeError("The string <\(sentenceText)> was not found in <\(entireText)>")
            }
        }
        
        let words = sentenceText.split(separator: " ")
        for word in words
        {
            self.words.append(SingleWord(text: String(word) + " ", sentenceId: self.id))
        }
        
    }
    
    init(entireText:String, sentenceText: String, status: SentenceStatus, correction: String? = nil, reason: String? = nil, range:[Int]? = nil) throws
    {
        self.status = status
        self.correction = correction
        self.reason = reason
        
        if let _range = range{
            self.range = _range
        }
        else
        {
            if let range = entireText.range(of: sentenceText){
                
                let lowerBoundInt = range.lowerBound.utf16Offset(in: entireText)
                let upperBoundInt = range.upperBound.utf16Offset(in: entireText)
                
                self.range = [lowerBoundInt, upperBoundInt]
            }
            else
            {
                throw SentenceError.runtimeError("The string <\(sentenceText)> was not found in <\(entireText)>")
            }
        }
        
        let words = sentenceText.split(separator: " ")
        for word in words
        {
            self.words.append(SingleWord(text: String(word) + " ", sentenceId: self.id))
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
    
    public func toString() -> String
    {
        var str: String = ""
        
        for word in words
        {
            str += word.getText()
        }
        
        return str
    }
    
    public func getReason() -> String?
    {
        return self.reason
    }
}

enum SentenceStatus: Codable {
    case okay, warning, wrong
}

