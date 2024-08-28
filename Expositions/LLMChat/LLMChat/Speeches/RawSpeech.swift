import Foundation

class RawSpeech: Identifiable, Codable{
    internal var id = UUID()
    private var textInString: String = ""
    private let textInSingleWords: [SingleWord]
    
    init(textInSingleWords: [SingleWord]) throws
    {
        if textInSingleWords.count == 0
        {
            throw Exception(exceptionName: "IllegalArgument", exceptionMessage: "Cannot create a RawSpeech from an empty text.") 
        }
        self.textInSingleWords = textInSingleWords
        self.textInString = SingleWord.singleWordsToString(textInSingleWords: self.textInSingleWords)
    }
    
    public func getId() -> UUID
    {
        return self.id
    }
    
    public func getText() -> String
    {
        return self.textInString
    }
    
    public func getTextInSingleWords() -> [SingleWord]
    {
        return self.textInSingleWords
    }
}
