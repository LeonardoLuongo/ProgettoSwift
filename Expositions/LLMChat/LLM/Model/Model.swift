
import GoogleGenerativeAI

class Model
{
    private let model: ModelImplementation
    init(systemInstruction: ModelContent)
    {
        let metadata = ModelMetadata(systemInstruction: systemInstruction)
        self.model = ModelImplementation(modelMetadata: metadata)
    }
    
    public func getResponse(query: String) async throws -> String?
    {
        do {
            return try await model.getResponse(query: query)
        }
        catch {
            throw error
        }
    }
}
