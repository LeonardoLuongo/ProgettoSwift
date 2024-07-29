//
//  ContentView.swift
//  Expositions1
//
//  Created by Studente on 05/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var sections: [Section] = loadSections()
    @State var expositions: [Int:[Exposition]] = loadExpositions()
    
    
    static var standardSections = [Section(name: "All expositions", symbol: "folder.fill", color: Color(red: 0.3568627450980392, green: 0.6627450980392157, blue: 0.9568627450980393), specialCode: 0), Section(name: "Favorites", symbol: "heart.fill", color: Color(red: 1, green: 0.27058823529411763, blue: 0.2235294117647059), specialCode: 1),Section(name: "Trash", symbol: "trash.fill", color: Color(red: 0.6784313725490196, green: 0.6784313725490196, blue: 0.6784313725490196), specialCode: 2)]
    
    var body: some View {
        Sections(sections: $sections, expositions: $expositions)
            .environment(\.locale, .init(identifier: "it"))
    }
    
    static func loadSections() -> [Section] {
        if let data = UserDefaults.standard.object(forKey: "sections") {
            do {
                let decoder = JSONDecoder()
                let sec = try decoder.decode([Section].self, from: data as! Data)
                return sec
            } catch {
                print("Impossible to decode. Error: \(error)")
            }
        }
        return standardSections
    }
    
    static func loadExpositions() -> [Int:[Exposition]] {
        var expositions: [Int:[Exposition]] = [:]
        let sections = loadSections()
        
        if let data = UserDefaults.standard.object(forKey: "expositions") {
            do {
                let decoder = JSONDecoder()
                expositions = try decoder.decode([Int:[Exposition]].self, from: data as! Data)
            } catch {
                print("Impossible to decode. Error: \(error)")
            }
        }
        
        for section in sections {
            if expositions[section.secCode] == nil {
                expositions[section.secCode] = []
            }
        }
        
        let keys = Array(expositions.keys)
        if let max = keys.max() {
            Section.lastCode = max + 1
        }
        
        let calendar = Calendar.current
        for exposition in expositions.flatMap({$0.value}).filter({$0.trash}) {
            if let expiryDate = calendar.date(byAdding: .day, value: 30, to: exposition.trashDate!) {
                if calendar.isDateInToday(expiryDate) {
                    expositions[2]?.removeAll(where: {$0.id == exposition.id})
                    Exposition.saveDictionary(expositions: expositions)
                }
            }
        }
        
        /* TO RESET THE DICTIONARY */
        // expositions.removeAll()
        // Exposition.saveDictionary(expositions: expositions)
        
        return expositions
    }
}
    
#Preview {
    ContentView()
}
