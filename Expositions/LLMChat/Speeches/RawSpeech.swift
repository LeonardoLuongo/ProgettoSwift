import Foundation

class RawSpeech: Identifiable{
    internal var id = UUID()
    private var textInString: String = ""
    private let textInSingleWords: [SingleWord]
    
    init(textInSingleWords: [SingleWord])
    {
        self.textInSingleWords = textInSingleWords
        self.textInString = SingleWord.singleWordsToString(textInSingleWords: self.textInSingleWords)
    }
    
    public func getId() -> UUID
    {
        return self.id
    }
    
    public func getTextInString() -> String
    {
        return self.textInString
    }
    
    public func getTextInSingleWords() -> [SingleWord]
    {
        return self.textInSingleWords
    }
}
