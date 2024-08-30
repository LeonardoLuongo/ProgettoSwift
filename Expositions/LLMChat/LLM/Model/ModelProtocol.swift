

protocol ModelProtocol {
    func getResponse(query: String) async throws -> String?
}
