import SwiftUI

struct ContentView: View {
    
    /* These are the main data structures where data is saved.
     sections containes both the general sections and the user-created sections. Once the app is opened, the sections are loaded from UserDefaults via the loadSections() method.
     expositions is a dictionary that containes arrays of Exposition-type objects. The keys (Int type) are sections' "secCode". Basically, an array of expositions is related to each section, representing the files (recording + document) created by the user. */
    @State var sections: [Section] = loadSections()
    @State var expositions: [Int:[Exposition]] = loadExpositions()
    @ObservedObject var exception: Exception = Exception(exceptionName: "Runtime exception", exceptionMessage: "Messaggio di errore. Si è verificata questa eccezione per questo motivo. Comportarsi in questo modo.")
    
    
    // This property represents the "general sections" (that are "All expositions", "Favorites" and "Trash").
    static var standardSections = [Section(name: "All expositions", symbol: "folder.fill", color: Color(red: 0.3568627450980392, green: 0.6627450980392157, blue: 0.9568627450980393), specialCode: 0), Section(name: "Favorites", symbol: "heart.fill", color: Color(red: 1, green: 0.27058823529411763, blue: 0.2235294117647059), specialCode: 1),Section(name: "Trash", symbol: "trash.fill", color: Color(red: 0.6784313725490196, green: 0.6784313725490196, blue: 0.6784313725490196), specialCode: 2)]
    
    var body: some View {
        ZStack {
            Sections(sections: $sections, expositions: $expositions)
                .environment(\.locale, .init(identifier: "it"))
            if exception.hasException {
                ExceptionView(exception: exception)
            }
            
        }
    }
    
    /* This method is used to load sections from UserDefaults */
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
        // If there's nothing to decode or if something went wrong, the array of standard sections will be returned
        return standardSections
    }
    
    /* This method is used to load the dictionary "expositions" from UserDefaults */
    static func loadExpositions() -> [Int:[Exposition]] {
        var expositions: [Int:[Exposition]] = [:]
        // It is necessary to load the sections because we want to initialize the dictionary with empty arrays of expositions fot the sections that have no exposition related to them.
        let sections = loadSections()
        
        if let data = UserDefaults.standard.object(forKey: "expositions") {
            do {
                let decoder = JSONDecoder()
                expositions = try decoder.decode([Int:[Exposition]].self, from: data as! Data)
            } catch {
                print("Impossible to decode. Error: \(error)")
            }
        }
        
        // We make sure to initialize a key-value pair for each section in the dictionary.
        for section in sections {
            if expositions[section.secCode] == nil {
                expositions[section.secCode] = []
            }
        }
        
        // In the struct "Section" there's a static property called "lastCode" that represents the last integer used to initialize a section's secCode. We make sure that lastCode is updated when we load the sections and expositions.
        let keys = Array(expositions.keys)
        if let max = keys.max() {
            Section.lastCode = max + 1
        }
        
        // We also need to update the Trash section. Once the app is opened, we check if any of the trashed expositions has expired. (An exposition stays in the trash for 30 days before being automatically and permantly removed).
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
