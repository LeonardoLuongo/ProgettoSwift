import Foundation

class PunctualizedSpeech: Codable
{
    internal var id = UUID()
    private let textInString: String
    private let textInSingleWords: [SingleWord]

    init(rawSpeech: RawSpeech) async throws {
        var punctualizedText: String = ""
        
        do{
            writeDebugLog("Waiting for Gemini response...")
            // Get the new punctualized text.
            if true
            {
                punctualizedText = try await LLMUtilis.addPuntuactionToText(rawSpeech.getText())
            }
            else
            {
                punctualizedText = PUNCTUALIZED_SPEECH
            }
        }
        catch
        {
            writeDebugLog("Error from Gemini call: \(error)")
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        punctualizedText = punctualizedText.replacingOccurrences(of: "\"", with: "\\\"")
        
        
        writeDebugLog("Copying the timestamps...")
        
        
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
        for i in 0...(punctualizedSingleStrWords.count - 1)
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
                throw LLMUtilsError.runtimeError("How the fuck did you get here? id:c76b53f0-8f0f-45e9-9894-d13000e6e7ce")
            }
            
            // Count how many chars have in common the thow versions
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
                // print("Warning: A totally different word was found after the LLM query.\nIn punctualized:<\(newSingleStrWord!)> in raw:<\(oldSingleStrWord)>.\n")
            }
            
        }
        
        self.textInSingleWords = newSingleWords
        self.textInString = SingleWord.singleWordsToString(textInSingleWords: textInSingleWords)
        
    }
    
    // TEST ONLY
    // ----------------------------------------
    // THOSE METHODS ARE GOING TO BE REMOVED IN RELEASE
    
    init(textInString: String)
    {
        self.textInString = textInString
        var textInSingleWords: [SingleWord] = []
        for singleStrWord in SingleWord.stringToSingleStrWords(text: textInString)
        {
            textInSingleWords.append(
                SingleWord(text: singleStrWord)
            )
        }
        self.textInSingleWords = textInSingleWords
    }
    
    // ----------------------------------------
    
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
            writeDebugLog("You should debug this thing. str1:>\(str1)<, str2:>\(str2)<")
            return 0
        }
        
        for i in 0...(size - 1){
            let appleShittyIndexStr1 = str1.index(str1.startIndex, offsetBy: i)
            let appleShittyIndexStr2 = str2.index(str2.startIndex, offsetBy: i)
            
            if str1[appleShittyIndexStr1] == str2[appleShittyIndexStr2]
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

