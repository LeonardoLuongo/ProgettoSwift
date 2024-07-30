import Foundation

// Define the structures to match the JSON structure
struct ErrorDetail: Codable {
    let sentence: String
    let correction: String
    let reason: String

    enum CodingKeys: String, CodingKey {
        case sentence = "Sentence"
        case correction = "Correction"
        case reason = "Reason"
    }
}

struct WarningDetail: Codable {
    let sentence: String
    let correction: String
    let reason: String

    enum CodingKeys: String, CodingKey {
        case sentence = "Sentence"
        case correction = "Correction"
        case reason = "Reason"
    }
}

struct FinalEvaluation: Codable {
    let grade: String
    let briefReason: String

    enum CodingKeys: String, CodingKey {
        case grade = "Grade"
        case briefReason = "BriefReason"
    }
}

struct Response: Codable {
    let errors: [ErrorDetail]
    let warnings: [WarningDetail]
    let advices: [String]
    let finalEvaluation: FinalEvaluation

    enum CodingKeys: String, CodingKey {
        case errors = "Errors"
        case warnings = "Warnings"
        case advices = "Advices"
        case finalEvaluation = "FinalEvaluation"
    }
}

