import SwiftUI

// This struct is used to represent and save informations of both the general sections and the user-created sections in which the expositions will be "saved"
struct Section: Identifiable, Codable {
    var id = UUID() // identifier
    var secCode: Int // secCode is used as a second identifier for sections. We manually assign a special code for general sections. For the other sections (user-created) a secCode will automatically be assigned. These codes are used as keys for the "expositions" dictionary and to have an easy way to manage sections.
    var name: String
    var icon: Icon? // An icon is assigned to each section. This icon can be ether an image or a symbol or just a colorful circle.
    
    static var lastCode = 2 // This static variable is used to keep track of the last code assigned to a section. It will be incremented each time a new section is created
    
    // Initializers
    init(name: String, image: UIImage?, symbol: String?, color: Color?) {
        self.name = name
        
        if let image = image {
            self.icon = Icon(image: image)
        }
        
        if let symbol = symbol {
            if let color = color {
                self.icon = Icon(symbol: symbol, color: color)
            } else {
                self.icon = Icon(symbol: symbol, color: Color(red: 0.7529411764705882, green: 0.7529411764705882, blue: 0.7529411764705882))
            }
        } else {
            if let color = color {
                self.icon = Icon(color: color)
            }
        }
        secCode = Section.generateCode()
    }
    
    init(name: String, symbol: String, color: Color, specialCode: Int) {
        self.name = name
        self.icon = Icon(symbol: symbol, color: color)
        self.secCode = specialCode
    }
    
    // Utility functions used to change the value of properties
    mutating func changeIcon(color: Color, symbol: String) {
        self.icon = Icon(symbol: symbol, color: color)
    }
    
    mutating func changeIcon(color: Color) {
        self.icon = Icon(color: color)
    }
    
    mutating func changeImage(image: UIImage) {
        self.icon = Icon(image: image)
    }
    
    mutating func changeName(name: String) {
        self.name = name
    }
    
    static func generateCode() -> Int {
        lastCode += 1
        return lastCode
    }
    
    // This method is used to save the "sections" array in UserDefaults
    static func save(sections: [Section]) {
        do {
            let data = try JSONEncoder().encode(sections)
            UserDefaults.standard.set(data, forKey: "sections")
        } catch {
            print("Impossible to save. Error: \(error)")
        }
    }
}

// This struct is used to represent the section icon
struct Icon: Identifiable, Codable {
    var id = UUID() // Identifier
    /* An icon is generally a circle-shaped image.
     1) Users can upload images to create icons.
     2) Users can create their icons in the app:
        2.1) They can choose just a color, that will be used to color the circle
        2.2) They can choose a color and one of the symbols (saved in Assets) */
    var symbol: String?
    var color: Color?
    var imageData: Data? // imageData is used to save images in UserDefaults
    
    var image: Image? {
        if let imageData = self.imageData {
            if let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        }
        return nil
    }
    
    enum CodingKeys: CodingKey {
        case id, symbol, colorRed, colorGreen, colorBlue, imageData
    }
    
    // Initializers
    init(color: Color) {
        self.color = color
    }
    
    init(symbol: String, color: Color) {
        self.symbol = symbol
        self.color = color
    }
    
    init(image: UIImage) {
        if let data = image.pngData() {
            self.imageData = data
        } else if let data = image.jpegData(compressionQuality: 0.5) {
            self.imageData = data
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        if let symbol = try? container.decode(String.self, forKey: .symbol) {
            self.symbol = symbol
        }
        if let colorComponentRed = try? container.decode(CGFloat.self, forKey: .colorRed) {
            if let colorComponentGreen = try? container.decode(CGFloat.self, forKey: .colorGreen) {
                if let colorComponentBlue = try? container.decode(CGFloat.self, forKey: .colorBlue) {
                    color = Color(red: colorComponentRed, green: colorComponentGreen, blue: colorComponentBlue)
                }
            }
        }
        if let imageData = try? container.decode(Data.self, forKey: .imageData) {
            self.imageData = imageData
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if let symbol = symbol {
            try container.encode(symbol, forKey: .symbol)
        }
        if let color = color {
            if let components = color.components() {
                try container.encode(components.red, forKey: .colorRed)
                try container.encode(components.green, forKey: .colorGreen)
                try container.encode(components.blue, forKey: .colorBlue)
            }
        }
        if let imageData = imageData {
            try container.encode(imageData, forKey: .imageData)
        }
    }
    
}

extension Color {
    func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let success = uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return success ? (red, green, blue, alpha) : nil
    }
}

