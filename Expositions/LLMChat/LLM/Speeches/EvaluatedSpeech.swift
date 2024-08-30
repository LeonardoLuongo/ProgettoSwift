import Foundation

extension String {
    // This function returns the ranges of a substring in a string
    func ranges(of searchString: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var startIndex = self.startIndex
        
        while startIndex < self.endIndex,
              let range = self.range(of: searchString, range: startIndex..<self.endIndex) {
            ranges.append(range)
            startIndex = range.upperBound
        }
        
        return ranges
    }
}

class EvaluatedSpeech: Codable
{
    // The speech in string.
    private let textInString: String
    
    // The speech in sentences.
    public var textInSentences: [Sentence]
    
    // All the wrong sentences.
    private var wrongSentences: [Int: Sentence] = [:]
    
    // All the okay sentences.
    private var okaySentences: [Int: Sentence] = [:]
    
    // All the warning sentences.
    private var warningSentences: [Int: Sentence] = [:]
    
    // The JSON response from LLM.
    private var response: Response? = nil
    
    
    init(context: String, punctualizedText: PunctualizedSpeech) async throws
    {
        // Copy the entire exposition
        self.textInString = punctualizedText.getText()
        
        // A sentence has got an unique range. However, the LLM could return the same sentence multiple times. It's a precaution.
        var allRanges: [[Int]] = []
        
        // Get the Gemini Response
        do
        {
            print("Waiting for Gemini response...")
            
            let model: EvaluatorModel = try EvaluatorModel()
            
            self.response = try await model.evaluate(context: context, exposition: punctualizedText.getText())
            /*
            self.response = try await LLMUtilitis.evaluate(context: context, exposition: punctualizedText.getText())
             */
        }
        catch
        {
            print("Got an error from Gemini call: \(error)")
            throw Exception(exceptionName: "GeminiCallError", exceptionMessage: error.self.localizedDescription)
        }
        print("From JSON to Sentence...")
        // From JSON format to Sentence
        
        var response = self.response!
        
        // Store all the wrong sentences
        var temp_wrongSentences: [Sentence] = []
        for error in response.errors {
            
            // A sentence could be repeated in the speech. Therefore, let's store all the ranges of the sentence
            let ranges = self.textInString.ranges(of: error.sentence)
            
            // For each range
            for range in ranges {
                // Let's convert the ranges into integer.
                let _range = [
                    range.lowerBound.utf16Offset(in: self.textInString),
                    range.upperBound.utf16Offset(in: self.textInString)
                ]
                
                do {
                    
                    // If the range is not occupied
                    if !EvaluatedSpeech.isRangeOccupied(ranges: allRanges, newRange: _range)
                    {
                        // Let's add it into the wrong sentences...
                        temp_wrongSentences.append(try Sentence(entireText: self.textInString, sentenceText: error.sentence, status: .wrong, correction: error.correction, reason: error.reason, range: _range))
                        
                        // ...and into the ranges.
                        allRanges.append(_range)
                    }
                    else
                    {
                        print("A sentence repetition was denied.")
                    }
                }
                catch{
                    throw error
                }
            }
            
        }
        
        // Store all the warning sentence
        var temp_warningSentences: [Sentence] = []
        for warn in response.warnings {
            // Same process as above for tempt_wrongSentences
            let ranges = EvaluatedSpeech.findAllRanges(of: warn.sentence, in: self.textInString)
            for range in ranges {
                let _range = [
                    range.lowerBound.utf16Offset(in: self.textInString),
                    range.upperBound.utf16Offset(in: self.textInString)
                ]
                do {
                    if !EvaluatedSpeech.isRangeOccupied(ranges: allRanges, newRange: _range)
                    {
                        temp_warningSentences.append(try Sentence(entireText: self.textInString, sentenceText: warn.sentence, status: .warning, correction: warn.correction, reason: warn.reason, range: _range))
                        allRanges.append(_range)
                    }
                    else
                    {
                        print("A sentence repetition was denied.")
                    }
                }
                catch{
                    throw error
                }
            }
            
        }
        
        // Getting ready to sort all the sentences
        
        // Sorted text
        self.textInSentences = []
        
        // All wrong and warning sentences
        var unsortedSentences: [Sentence] = temp_wrongSentences + temp_warningSentences
        
        // Imagine to write the text letter by letter.
        // This wordTextCursor just points out
        // the number of word we are at.
        var letterTextCursor = 0
        
        // JSON repots only the warning and the wrong sentences,
        // let's say the unsortedSentences[0] is not next to unsortedSentences[1]
        // but we have some words in between.
        // We can be sure that those words can be merged as a correct sentence.
        // This sentence is stored here.
        var paddingSentence: Sentence
        
        // This is an identifier used to build the entire text using the sentences.
        // unsortedSentences[0] can be after the unsortedSentences[1]. Therefore,
        // we must create a dictionary with Int:Sentence as type.
        // The first sentence'll be the one with index = 0, the second with index = 1 and so on...
        var sentenceCounter = 0
        
        // In unsortedSentenceIndex we have all the warning and wrong sentences.
        // We have to find the sentences who comes first, so, the one who has
        // a .getRange()[0] that is the lowest.
        var (min_unsortedSentencesIndex, currentSentence): (Int?, Sentence)
        while(letterTextCursor < textInString.count)
        {
            // If the array is not empty
            if !unsortedSentences.isEmpty
            {
                // We have to gather is the first wrong sentence.
                if let (_min_unsortedSentencesIndex, _) = unsortedSentences.enumerated().min(by: {
                    $0.element.getRange()[0] < $1.element.getRange()[0]
                })
                {
                    // Get the min and removing that from the sentence to write in evaluated text
                    min_unsortedSentencesIndex = _min_unsortedSentencesIndex
                    currentSentence = unsortedSentences.remove(at: min_unsortedSentencesIndex!)
                }
                else
                {
                    // Something impossible
                    throw Exception(exceptionName: "UnexpectedBehaviour", exceptionMessage: "Min was not found, that must be impossible.")
                }
            }
            else
            {
                // if the array is empty it means everything is okay.
                let index = textInString.index(textInString.startIndex, offsetBy: letterTextCursor)
                min_unsortedSentencesIndex = nil
                currentSentence = try Sentence(
                    entireText: textInString,
                    sentenceText: String(textInString.suffix(from: index)),
                    status: .okay,
                    range: [letterTextCursor, textInString.count]
                )
            }
            
            // if the first not-okay-sentence is away from where we was pointing since the last iteration
            if letterTextCursor < currentSentence.getRange()[0]
            {
                // Get the string that fils the gap
                let okaySenteceStr = EvaluatedSpeech.substring(
                    of: textInString,
                    from: letterTextCursor,
                    to: currentSentence.getRange()[0]
                )
            
                // Let's create the sentence
                do{
                    paddingSentence = try Sentence(
                        entireText: textInString,
                        sentenceText: String(okaySenteceStr),
                        status: .okay
                    )
                }catch{
                    throw error
                }
                
                // We can add it to the okay sentences
                okaySentences.updateValue(paddingSentence, forKey: sentenceCounter)
                letterTextCursor += okaySenteceStr.count
                sentenceCounter += 1
            }
            
            // If the cursor is the right position
            if letterTextCursor == currentSentence.getRange()[0]
            {
                // Identify the Sentence Status and add it to the correct status-based array
                switch currentSentence.getStatus()
                {
                case .okay:
                    okaySentences.updateValue(currentSentence, forKey: sentenceCounter)
                    break
                case .wrong:
                    wrongSentences.updateValue(currentSentence, forKey: sentenceCounter)
                    break
                    
                case .warning:
                    warningSentences.updateValue(currentSentence, forKey: sentenceCounter)
                    break
                    
                default:
                    throw Exception(exceptionName: "UnexpectedBehaviour", exceptionMessage: "You reached the default section in the switch that must be unreachable.")
                    
                }
                letterTextCursor += currentSentence.toString().count
                sentenceCounter += 1
                
            }else if letterTextCursor > currentSentence.getRange()[0]{
                throw Exception(exceptionName: "UnexpectedBehaviour", exceptionMessage: "Cursor is ahead .")
            }
        }
        do{
            // We have to create a dumb data to fill the array with some sentences
            textInSentences = Array(
                repeating: try Sentence(
                    entireText: "a ",
                    words: [SingleWord(text: "a")],
                    status: .wrong
                ),
                count: sentenceCounter
            )
        }
        catch{
            throw error
        }
        
        // For each index
        for i in 0...(sentenceCounter - 1)
        {
            // Get the sentence ignoring the status and put it in the textInSentences
            if let _okay = okaySentences[i]
            {
                textInSentences[i] = _okay
            }
            else if let _warn = warningSentences[i]
            {
                textInSentences[i] = _warn
            }
            else if let _wrong = wrongSentences[i]
            {
                textInSentences[i] = _wrong
            }
            else
            {
                throw Exception(exceptionName: "SentenceNotFound", exceptionMessage: "There's a missing sentence. [no sencence found at index: \(i)]") 
            }
        }
    }
    
    public func getTextInSentences() throws -> [Sentence] 
    {
        var sentences: [Sentence] = []
        let maxIndex = (self.okaySentences.count) + (self.wrongSentences.count) + (self.warningSentences.count)
        
        for i in 0...(maxIndex - 1) {
            if let _sentence = okaySentences[i]
            {
                sentences.append(_sentence)
            }
            else if let _sentence = warningSentences[i]
            {
                sentences.append(_sentence)
            }
            else if let _sentence = wrongSentences[i]
            {
                sentences.append(_sentence)
            }
            else
            {
                throw Exception(exceptionName: "SentenceNotFound", exceptionMessage: "There's a missing sentence. [no sencence found at index: \(i)]") 
            }
        }
        
        return sentences
    }
    
    public func getText() -> String
    {
        return self.textInString
    }
    
    
    private static func findAllRanges(of substring: String, in mainString: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var searchRange: Range<String.Index>?
        
        while let range = mainString.range(of: substring, options: [], range: searchRange) {
            ranges.append(range)
            
            // Update the search range to start from the end of the last found range
            searchRange = range.upperBound..<mainString.endIndex
        }
        
        return ranges
    }
    
    private static func substring(of str: String, from index0: Int, to index1: Int) -> String
    {
        var i = index0
        var subStr = ""
        while i < index1
        {
            let appleStrangeIndex = str.index(str.startIndex, offsetBy: i)
            subStr.append(str[appleStrangeIndex])
            i += 1
        }
        return subStr
    }
    
    private static func isRangeOccupied(ranges: [[Int]], newRange: [Int]) -> Bool {
        // Ensure the new range has exactly 2 elements
        guard newRange.count == 2 else {
            return false
        }
        
        let newStart = newRange[0]
        let newEnd = newRange[1]
        
        for range in ranges {
            let start = range[0]
            let end = range[1]
            
            // Check for overlap
            if newStart <= end && newEnd >= start {
                return true
            }
        }
        
        return false
    }
    
    public func numberOfBadSentences() -> Int {
        return wrongSentences.count + warningSentences.count
    }
    
    public func getBadSentence (index: Int) -> (prevSentence: Sentence?, mainSentence: Sentence, nextSentence: Sentence?) {
        let badSentences = Array(wrongSentences.values) + Array(warningSentences.values)
        let mainSentence = badSentences[index]
        
        if let i = textInSentences.firstIndex(where: {$0.id == mainSentence.id}) {
            var prevSentence: Sentence?
            var nextSentence: Sentence?
            if i != 0 {
                prevSentence = textInSentences[i - 1]
            } else {
                prevSentence = nil
            }
            if i < textInSentences.count - 1 {
                nextSentence = textInSentences[i + 1]
            } else {
                nextSentence = nil
            }
            return (prevSentence, mainSentence, nextSentence)
        }
        return (nil, mainSentence, nil)
    }
    
    public func getResponse() -> Response?
    {
        return self.response
    }

}

