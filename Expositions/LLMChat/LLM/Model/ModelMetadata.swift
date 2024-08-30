
import GoogleGenerativeAI

struct ModelMetadata
{
    // Specify a Gemini model appropriate for your use case
    let name: String = "gemini-1.5-flash"
    
    // Access your API key from your on-demand resource .plist file (see "Set up your API key" above)
    let apiKey: String = APIKey.default
    
    let safetySettings: [SafetySetting] = [
        SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone),
        SafetySetting(harmCategory: .harassment, threshold: .blockNone),
        SafetySetting(harmCategory: .hateSpeech, threshold: .blockNone),
        SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockNone)
    ]
    
    var systemInstruction: ModelContent?
    
    var requestOptions: RequestOptions
    
    init(
        systemInstruction: ModelContent? = nil,
        requestOptions: RequestOptions = RequestOptions(timeout: 100_000.0)
    ) {
        self.systemInstruction = systemInstruction
        self.requestOptions = requestOptions
    }
}
