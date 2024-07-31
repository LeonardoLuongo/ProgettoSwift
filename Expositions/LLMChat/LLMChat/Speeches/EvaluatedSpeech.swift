import Foundation

extension String {
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
    private let textInString: String
    public let textInSentences: [Sentence]
    private var wrongSentences: [Int: Sentence] = [:]
    private var okaySentences: [Int: Sentence] = [:]
    private var warningSentences: [Int: Sentence] = [:]
    
    init(text: String, textInSentences: [Sentence]) {
        self.textInString = text
        self.textInSentences = textInSentences
        
        var index: Int = 0
        for sentence in textInSentences {
            if sentence.getStatus() == .okay
            {
                okaySentences.updateValue(sentence, forKey: index)
            }
            else if sentence.getStatus() == .warning
            {
                warningSentences.updateValue(sentence, forKey: index)
            }
            else if sentence.getStatus() == .wrong
            {
                wrongSentences.updateValue(sentence, forKey: index)
            }
            index += 1
        }
    }
    
    init(context: String, punctualizedText: PunctualizedSpeech) async throws
    {
        // Copy the entire exposition
        self.textInString = punctualizedText.getText()
        
        // Get the Gemini Response
        var evaluatedText: Response
        do
        {
            writeDebugLog("Waiting for Gemini response...")
            evaluatedText = try await LLMUtilis.evaluate(context: context, exposition: punctualizedText.getText())
        }
        catch
        {
            writeDebugLog("Got an error from Gemini call: \(error)")
            throw LLMUtilsError.runtimeError("\(error)")
        }
        writeDebugLog("From JSON to Sentence...")
        // From JSON format to Sentence
        
        // Store all the wrong sentences
        var temp_wrongSentences: [Sentence] = []
        for error in evaluatedText.errors {
            
            let ranges = self.textInString.ranges(of: error.sentence)
            
            for range in ranges {
                let _range = [
                    range.lowerBound.utf16Offset(in: self.textInString),
                    range.upperBound.utf16Offset(in: self.textInString)
                ]
                do {
                    temp_wrongSentences.append(try Sentence(entireText: self.textInString, sentenceText: error.sentence, status: .wrong, correction: error.correction, reason: error.reason, range: _range))
                }
                catch{
                    throw LLMUtilsError.runtimeError("\(error)")
                }
            }
            
        }
        
        // Store all the warning sentence
        let temp_warningSentences: [Sentence] = []
        for warn in evaluatedText.warnings {
            
            let ranges = EvaluatedSpeech.findAllRanges(of: warn.sentence, in: self.textInString)
            for range in ranges {
                let _range = [
                    range.lowerBound.utf16Offset(in: self.textInString),
                    range.upperBound.utf16Offset(in: self.textInString)
                ]
                do {
                    temp_wrongSentences.append(try Sentence(entireText: self.textInString, sentenceText: warn.sentence, status: .wrong, correction: warn.correction, reason: warn.reason, range: _range))
                }
                catch{
                    throw LLMUtilsError.runtimeError("\(error)")
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
        while(letterTextCursor < textInString.count - 1)
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
                    throw LLMUtilsError.runtimeError("Min not found.")
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
                    range: [letterTextCursor, textInString.count - 1]
                )
            }
            
            // if the first not okay sentence is away from where we was pointing since the last iteration
            if letterTextCursor < currentSentence.getRange()[0]
            {
                // Get the string that fils the gap
                let okaySenteceStr = EvaluatedSpeech.substring(of: textInString, from: letterTextCursor, to: currentSentence.getRange()[0])
            
                
                // Let's create the sentence
                do{
                    paddingSentence = try Sentence(entireText: textInString, sentenceText: String(okaySenteceStr), status: .okay)
                }catch{
                    throw LLMUtilsError.runtimeError("\(error)")
                }
                
                // We can add it to the okay sentences
                okaySentences.updateValue(paddingSentence, forKey: sentenceCounter)
                letterTextCursor += okaySenteceStr.count
                sentenceCounter += 1
            }
            
            if letterTextCursor == currentSentence.getRange()[0]
            {
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
                    throw LLMUtilsError.runtimeError("How the fuck did you get here? id:af2377a5-8f5f-4375-89af-acb3500347cd")
                    
                }
                // TODO: Understand if should be
                // letterTextCursor += currentSentence.getText().count
                // Instead of:
                letterTextCursor += currentSentence.getText().count - 1
                sentenceCounter += 1
                
            }else if letterTextCursor > currentSentence.getRange()[0]{
                var text: String = ""
                
                for i in 0...(self.textInSentences.count - 1) {
                    text += (self.textInSentences[i]).getText()
                }
                
                print(text)
                throw LLMUtilsError.runtimeError("How the fuck did you get here? id:0a2208b8-de05-4fee-b2ad-fa493feaf8fe")
                
            }
        }
    }
    
    public func getTextInSentences() -> [Sentence]
    {
        var sentences: [Sentence] = []
        let maxIndex = (self.okaySentences.count - 1) + (self.wrongSentences.count - 1) + (self.warningSentences.count - 1)
        
        for i in 0...maxIndex {
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
                print("!!! You shouldn't be here !!!")
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
            let appleShittyIndex = str.index(str.startIndex, offsetBy: i)
            subStr.append(str[appleShittyIndex])
            i += 1
        }
        return subStr
    }
    

}

/*
 
 * nome dell'app in virgolette
 *
 *
 
 
 * API Per la traduzione delle label
 
*/
