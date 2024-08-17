import SwiftUI

// This class represents a generic file created by the user.
class Exposition: ObservableObject, Identifiable, Codable {
    // Identifier
    var id = UUID()
    
    // Observable properties
    @Published var favorite: Bool = false // The user can mark expositions as favorite
    @Published var trash: Bool = false { // The user can put expositions in the trash
        didSet {
            if trash {
                self.trashDate = Date()
            }
        }
    }
    @Published var evaluated: Bool = false
    
    // Other properties
    var date: Date // Creation date
    var recordingManager: RecordingManager // RecordingManager is an object that is necessary to manage all the recording-related properties
    @Published var grade: String = "..." // Grade will be assigned by Gemini once the exposition is evaluated. For now, it is initialized with "..." (meaning that the exposition has not been evaluated yet)
    var finalEvaluation: String? // This brief description explains the reason why Gemini gave a certain grade to this exposition
    var secCode: Int // This property is necessary to keep track of the section where the exposition is. We need this property, because, when the user wants to restore an exposition from the trash, we will use this code to know which section the exposition was originally in.
    var trashDate: Date? // When the user puts the exposition in the trash. 30 days after this date, the exposition will be automatically deleted.
    
    var evaluatedSpeech: EvaluatedSpeech? // Once the exposition is evaluated, we will save all the informations (errors, corrections, warnings, etc.) in this property.
    
    // This coding keys will be used to code the exposition and save it in UserDefaults
    enum CodingKeys: CodingKey {
        case id, favorite, trash, evalueted, date, grade, secCode, trashDate, recordingManager, evaluatedSpeech, finalEvaluation
    }
    
    // Initializer
    init(date: String, secCode: Int?) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current

        if dateFormatter.locale.language.languageCode!.identifier == "it" {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        } else {
            dateFormatter.dateFormat = "MM.dd.yyyy"
        }
        
        self.date = dateFormatter.date(from: date) ?? Date()
        self.recordingManager = RecordingManager()
        self.secCode = secCode ?? 0
    }
    
    init(date: Date, secCode: Int?) {
        self.date = date
        self.recordingManager = RecordingManager()
        self.secCode = secCode ?? 0
    }
    
    init(date: String, grade: String, secCode: Int?) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current

        if dateFormatter.locale.language.languageCode!.identifier == "it" {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        } else {
            dateFormatter.dateFormat = "MM.dd.yyyy"
        }
        
        self.date = dateFormatter.date(from: date) ?? Date()
        self.recordingManager = RecordingManager()
        self.grade = grade
        self.secCode = secCode ?? 0
    }
    
    init(date: String, grade: String, secCode: Int?, trash: Bool, trashDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current

        if dateFormatter.locale.language.languageCode!.identifier == "it" {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        } else {
            dateFormatter.dateFormat = "MM.dd.yyyy"
        }
        
        self.date = dateFormatter.date(from: date) ?? Date()
        self.recordingManager = RecordingManager()
        self.grade = grade
        self.secCode = secCode ?? 0
        self.trash = trash
        self.trashDate = trashDate
    }
    
    init(date: Date, recordingManager: RecordingManager, secCode: Int?) {
        self.date = date
        self.recordingManager = recordingManager
        self.secCode = secCode ?? 0
    }
    
    // Utility Function, used to have different colors associated to a certain grade
    func gradeStyle() -> (textColor: Color, background: Color) {
        switch grade {
        case "...":
            return (Color(red: 0, green: 0, blue: 0), Color(red: 173/255, green: 173/255, blue: 173/255))
        case "1":
            return (Color(red: 181/255, green: 26/255, blue: 0/255), Color(red: 131/255, green: 17/255, blue: 0/255))
        case "2":
            return (Color(red: 255/255, green: 64/255, blue: 21/255), Color(red: 181/255, green: 26/255, blue: 0/255))
        case "3":
            return (Color(red: 181/255, green: 26/255, blue: 0/255), Color(red: 255/255, green: 64/255, blue: 21/255))
        case "4":
            return (Color(red: 226/255, green: 36/255, blue: 0/255), Color(red: 254/255, green: 98/255, blue: 80/255))
        case "5":
            return (Color(red: 255/255, green: 64/255, blue: 21/255), Color(red: 255/255, green: 140/255, blue: 130/255))
        case "6":
            return (Color(red: 211/255, green: 131/255, blue: 1/255), Color(red: 254/255, green: 180/255, blue: 63/255))
        case "7":
            return (Color(red: 150/255, green: 211/255, blue: 95/255), Color(red: 220/255, green: 247/255, blue: 195/255))
        case "8":
            return (Color(red: 118/255, green: 187/255, blue: 64/255), Color(red: 205/255, green: 232/255, blue: 181/255))
        case "9":
            return (Color(red: 78/255, green: 122/255, blue: 39/255), Color(red: 150/255, green: 211/255, blue: 95/255))
        case "10":
            return (Color(red: 56/255, green: 87/255, blue: 26/255), Color(red: 118/255, green: 187/255, blue: 64/255))
        default:
            return (Color(red: 0, green: 0, blue: 0), Color(red: 0, green: 0, blue: 0))
        }
    }
    
    // Coder & Decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        favorite = try container.decode(Bool.self, forKey: .favorite)
        trash = try container.decode(Bool.self, forKey: .trash)
        evaluated = try container.decode(Bool.self, forKey: .evalueted)
        date = try container.decode(Date.self, forKey: .date)
        grade = try container.decode(String.self, forKey: .grade)
        finalEvaluation = try container.decodeIfPresent(String.self, forKey: .finalEvaluation)
        secCode = try container.decode(Int.self, forKey: .secCode)
        trashDate = try container.decodeIfPresent(Date.self, forKey: .trashDate)
        recordingManager = try container.decode(RecordingManager.self, forKey: .recordingManager)
        evaluatedSpeech = try container.decodeIfPresent(EvaluatedSpeech.self, forKey: .evaluatedSpeech)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(favorite, forKey: .favorite)
        try container.encode(trash, forKey: .trash)
        try container.encode(evaluated, forKey: .evalueted)
        try container.encode(date, forKey: .date)
        try container.encode(grade, forKey: .grade)
        try container.encodeIfPresent(finalEvaluation, forKey: .finalEvaluation)
        try container.encode(secCode, forKey: .secCode)
        try container.encodeIfPresent(trashDate, forKey: .trashDate)
        try container.encode(recordingManager, forKey: .recordingManager)
        try container.encodeIfPresent(evaluatedSpeech, forKey: .evaluatedSpeech)
    }
    
    func insertFinalEvaluation() {
        if let finalEvaluation = evaluatedSpeech?.getResponse()?.finalEvaluation {
            var gradeDouble = Double(finalEvaluation.grade)
            if let gradeDouble = gradeDouble {
                self.grade = String(Int(ceil(gradeDouble)))
            }
            self.finalEvaluation = finalEvaluation.briefReason
        }
    }
    
    // This function is used to save the current dictionary of expositions in UserDefaults
    static func saveDictionary(expositions: [Int:[Exposition]]) {
        do {
            let data = try JSONEncoder().encode(expositions)
            UserDefaults.standard.set(data, forKey: "expositions")
        } catch {
            print("Impossible to save. Error: \(error)")
        }
    }
}
