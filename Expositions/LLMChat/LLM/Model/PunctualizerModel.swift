import GoogleGenerativeAI


class PunctualizerModel: Model
{
    private let systemInstruction = """
Sei un professore di italiano e devi inserire la punteggiatura a questo testo senza alterarne il numero di parole e senza riassumerlo. Solo la punteggiatura. Senza asterischi.
"""
    
    init() throws {
        
        let metadata = ModelMetadata(systemInstruction: ModelContent(
            role: "system",
            parts: [.text(systemInstruction)])
        )
        
        super.init(modelMetadata: metadata)
    }
    
    public func punctualize(text: String, context: String) async throws -> String
    {
        let query = PunctualizationQuery(text: text, context: context)
        var retVal: String? = nil
        do
        {
            retVal = try await super.getResponse(query: query.toString())
            
        }
        catch
        {
            throw error
        }
        
        if let punctualizedText = retVal
        {
            return punctualizedText
        }
        else
        {
            throw Exception(exceptionName: "InvalidGeminiResponse", exceptionMessage: "Cannot insert punctualization to the text. [punctualizedText is nil]")
        }
    }
}
