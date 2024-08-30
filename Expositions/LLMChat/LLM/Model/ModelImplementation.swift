import GoogleGenerativeAI

class ModelImplementation: ModelProtocol
{
    let generativeModel: GenerativeModel
    
    init(modelMetadata: ModelMetadata)
    {
        self.generativeModel = GenerativeModel(
          name: modelMetadata.name,
          apiKey: modelMetadata.apiKey,
          safetySettings: modelMetadata.safetySettings,
          systemInstruction: modelMetadata.systemInstruction,
          requestOptions: modelMetadata.requestOptions
        )
    }
    
    func getResponse(query: String) async throws -> String?
    {
        // [START text_gen_text_only_prompt_streaming]
        var responseData:String? = nil
        
        // Use streaming with text-only input
        do
        {
            
            for try await response in self.generativeModel.generateContentStream(query) 
            {
              if let text = response.text {
                  if responseData == nil
                  {
                      responseData = ""
                  }
                  responseData! += text
                  print("Got a piece of the total response.")
              }
            }
        }
        catch
        {
            throw error
        }
        
        // [END text_gen_text_only_prompt_streaming]
        
        return responseData
    }
    
}
