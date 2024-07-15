//
//  ContentView.swift
//  Expositions1
//
//  Created by Studente on 05/07/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        Sections(sections: [Section(name: "Science", image: nil, symbol: "atom", color: Color(red: 0.6941176470588235, green: 0.8666666666666667, blue: 0.5450980392156862)),Section(name: "History", image: nil, symbol: "fossil.shell.fill", color: Color(red: 0.996078431372549, green: 0.7058823529411765, blue: 0.24705882352941178)),Section(name: "Literature", image: Image("shakespeare"), symbol: nil, color: nil)])
    }
}

#Preview {
    ContentView()
}

struct Section: Identifiable {
    var id = UUID()
    var name: String
    var icon: Icon?
        
    init(name: String, image: Image?, symbol: String?, color: Color?) {
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
    }
}

struct Icon {
    var image: Image?
    var symbol: String?
    var color: Color?
}
