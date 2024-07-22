//
//  Section.swift
//  Expositions
//
//  Created by Studente on 20/07/24.
//

import SwiftUI

struct Section: Identifiable, Codable {
    var id = UUID()
    var secCode: Int
    var name: String
    var icon: Icon?
    
    static var lastCode = 2
    
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
    
    static func save(sections: [Section]) {
        do {
            let data = try JSONEncoder().encode(sections)
            UserDefaults.standard.set(data, forKey: "sections")
        } catch {
            print("Impossible to save. Error: \(error)")
        }
    }
}

struct Icon: Identifiable, Codable {
    var id = UUID()
    var symbol: String?
    var color: Color?
    var imageData: Data?
    
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

