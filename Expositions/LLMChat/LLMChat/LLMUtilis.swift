import GoogleGenerativeAI
import Foundation

enum LLMUtilsError: Error {
    case runtimeError(String)
}

class LLMUtilis
{
    
    private static func buildEvaluationQuery(context: String, exposition: String) -> String
    {
        return EvaluationQuery(context: context, exposition: exposition).toString()
    }
    
    private static func buildPunctualizationQuery(text: String) -> String
    {
        return PunctualizationQuery(text: text).toString()
    }
    
    private static func geminiCall(query: String) async throws -> String?
    {
        // [START text_gen_text_only_prompt_streaming]
        let generativeModel =
          GenerativeModel(
            // Specify a Gemini model appropriate for your use case
            name: "gemini-1.5-flash",
            // Access your API key from your on-demand resource .plist file (see "Set up your API key"
            // above)
            apiKey: APIKey.default,
            safetySettings: [
                SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone),
                SafetySetting(harmCategory: .harassment, threshold: .blockNone),
                SafetySetting(harmCategory: .hateSpeech, threshold: .blockNone),
                SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockNone)
            ]
          )
        
        var responseData:String? = nil
        // Use streaming with text-only input
        do
        {
            
            for try await response in generativeModel.generateContentStream(query) {
              if let text = response.text {
                  if responseData == nil
                  {
                      responseData = ""
                  }
                  responseData! += text
                  writeDebugLog("Got a piece of the total response.")
              }
            }
        }
        catch
        {
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        // [END text_gen_text_only_prompt_streaming]
        
        return responseData
    }
    
    public static func addPuntuactionToText(_ text: String) async throws -> String
    {
        let query = PunctualizationQuery(text: text)
        var retVal: String? = nil
        do
        {
            retVal = try await LLMUtilis.geminiCall(query: query.toString())
        }
        catch
        {
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        if let punctualizedText = retVal
        {
            return punctualizedText
        }
        else
        {
            throw LLMUtilsError.runtimeError("Cannot insert punctualization to the text.")
        }
    }
    
    
    public static func evaluate(context: String, exposition: String) async throws -> Response
    {
        let query = EvaluationQuery(context: context, exposition: exposition)
        var responseData:String?
        do
        {
            responseData = try await LLMUtilis.geminiCall(query: query.toString())
        }
        catch
        {
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        var response: Response? = nil
        
        if let data = responseData
        {
            if let jsonData = data.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    response = try decoder.decode(Response.self, from: jsonData)
                } catch {
                    throw LLMUtilsError.runtimeError("Error decoding JSON: \(error)")
                }
            }
        }
        
        return response!
    }
}
