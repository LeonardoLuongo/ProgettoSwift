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
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.correction = try container.decode(String.self, forKey: .correction)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason) ?? ""
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
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.correction = try container.decode(String.self, forKey: .correction)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason) ?? ""
    }
}

struct FinalEvaluation: Codable {
    let grade: String
    let briefReason: String

    enum CodingKeys: String, CodingKey {
        case grade = "Grade"
        case briefReason = "BriefReason"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.grade = try container.decode(String.self, forKey: .grade)
        self.briefReason = try container.decodeIfPresent(String.self, forKey: .briefReason) ?? ""
    }
}

struct Response: Codable {
    let errors: [ErrorDetail]
    let warnings: [WarningDetail]
    let finalEvaluation: FinalEvaluation

    enum CodingKeys: String, CodingKey {
        case errors = "Errors"
        case warnings = "Warnings"
        case finalEvaluation = "FinalEvaluation"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.errors = try container.decodeIfPresent([ErrorDetail].self, forKey: .errors) ?? []
            self.warnings = try container.decodeIfPresent([WarningDetail].self, forKey: .warnings) ?? []
            self.finalEvaluation = try container.decode(FinalEvaluation.self, forKey: .finalEvaluation)
    }
}

