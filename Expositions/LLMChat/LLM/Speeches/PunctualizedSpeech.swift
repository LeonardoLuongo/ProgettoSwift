import Foundation
import GoogleGenerativeAI

class PunctualizedSpeech: Codable
{
    internal var id = UUID()
    private let textInString: String
    private let textInSingleWords: [SingleWord]
    
    init(rawSpeech: RawSpeech, context: String) async throws {
        var punctualizedText: String = ""
        
        do{
            print("Waiting for Gemini response...")
            let query = PunctualizationQuery(text: rawSpeech.getText(), context: context)
            
            // Get the new punctualized text.
            let model: Model = Model(
                systemInstruction: ModelContent(
                    role: "system",
                    parts: [.text("")]
                )
            )
            let stringResponse: String? = try await model.getResponse(query: query.toString())
            
            let punctualizer = try PunctualizerModel()
            
            punctualizedText = try await punctualizer.punctualize(text: rawSpeech.getText(), context: context)
            
        }
        catch
        {
            print("Error from Gemini call: \(error)")
            throw Exception(exceptionName: "GeminiCallError", exceptionMessage: error.self.localizedDescription)
        }
        
        punctualizedText = punctualizedText.replacingOccurrences(of: "\"", with: "\\\"")
        punctualizedText = punctualizedText.replacingOccurrences(of: "\n", with: "")
        
        print("Copying the timestamps...")
        
        
        // From the entire punctualized text to array of words.
        let punctualizedSingleStrWords: [String] = SingleWord.stringToSingleStrWords(text: punctualizedText)
        
        // From the entire old not punctualized text to array of words.
        let rawSingleWords: [SingleWord] = rawSpeech.getTextInSingleWords()
        
        // Container for the new single words punctualized.
        var newSingleWords: [SingleWord] = []
        
        // The begin of text
        var rawSentenceIndex = 0
        
        // The last timestamp for all those words who was not well sampled from text-to-speech
        var lastTimeStamp = rawSpeech.getTextInSingleWords()[0].getTimestamp()
        
        // New single word in string
        var newSingleStrWord:String?
        
        var oldSingleStrWord: String
        
        // For every old single word...
        for i in 0...(min(punctualizedSingleStrWords.count, rawSingleWords.count) - 1)
        {
            // It removes the punctualization from the current word
            newSingleStrWord = PunctualizedSpeech.removePunctuation(from: punctualizedSingleStrWords[i])?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            
            oldSingleStrWord = rawSingleWords[i]
                .getText()
                .trimmingCharacters(in:.whitespacesAndNewlines)
                .lowercased()
            
            // If somehow it gets an error
            if newSingleStrWord == nil
            {
                throw Exception(exceptionName: "UnexpectedBehaviour", exceptionMessage: "The word at position \(i) was not found in the punctualized version.") 
            }
            
            // Count how many chars have in common the two versions
            // (it's used because the LLM may correct the raw text, maybe a word can be misspelled)
            let commonCharsCount = PunctualizedSpeech.commonCharactersCount(
                oldSingleStrWord,
                newSingleStrWord!
            )
            
            // If they are the same, it was well sampled.
            if commonCharsCount == newSingleStrWord!.count
            {
                // We can store it with the proper timestamp.
                newSingleWords.append(
                    SingleWord(
                        text: punctualizedSingleStrWords[i],
                        timestamp: rawSingleWords[i].getTimestamp(),
                        isTimestampCaptured: true
                    )
                )
                lastTimeStamp = rawSingleWords[i].getTimestamp()
            }
            // If something is common
            else if commonCharsCount > 0
            {
                // We will use the nearest timestamp
                newSingleWords.append(
                    SingleWord(
                        text: punctualizedSingleStrWords[i],
                        timestamp: rawSingleWords[i].getTimestamp(),
                        isTimestampCaptured: false
                    )
                )
            }
            // If there's nothing in common
            else
            {
                // We will use the nearest timestamp
                newSingleWords.append(
                    SingleWord(
                        text: punctualizedSingleStrWords[i],
                        timestamp: lastTimeStamp,
                        isTimestampCaptured: false
                    )
                )
            }
            
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
    
    public func getText() -> String
    {
        return self.textInString
    }

    // Function to remove punctuation characters using regular expression
    private static func removePunctuation(from string: String) -> String? {
        // Define the regular expression pattern for punctuation characters
        let pattern = "[\\p{P}]"
        
        // Create the regular expression
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        // Replace matches in the input string with an empty string
        let range = NSRange(location: 0, length: string.utf16.count)
        let modifiedString = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
        
        return modifiedString
    }
    
    private static func commonCharactersCount(_ str1: String, _ str2: String) -> Int {
        var commonChars = 0
        
        let size = min(str1.count, str2.count)
        
        if (size-1) < 0
        {
            print("You should debug this thing. str1:>\(str1)<, str2:>\(str2)<")
            return 0
        }
        
        for i in 0...(size - 1){
            let appleStrangeIndexStr1 = str1.index(str1.startIndex, offsetBy: i)
            let appleStrangeIndexStr2 = str2.index(str2.startIndex, offsetBy: i)
            
            if str1[appleStrangeIndexStr1] == str2[appleStrangeIndexStr2]
            {
                commonChars += 1
            }
        }
        
        return commonChars
    }
    
    func indexOf(substring: String, in string: String) -> Int? 
    {
        if let range = string.range(of: substring) {
            // Get the distance from the start of the string to the lower bound of the range
            let index = string.distance(from: string.startIndex, to: range.lowerBound)
            return index
        }
        return nil
    }
    
}

