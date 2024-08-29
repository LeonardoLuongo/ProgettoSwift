//
//  ExpositionRowTrash.swift
//  Expositions
//
//  Created by Studente on 20/07/24.
//

import SwiftUI

struct ExpositionRowTrash: View {
    @Binding var expositions: [Int:[Exposition]]
    @Binding var section: Section
    @Binding var sections: [Section]
    @State var exposition: Exposition
    var subjectExp: [Exposition]
    
    @Binding var refreshID: UUID
    
    static let backgroundColor = [Color(red: 229/255, green: 247/255, blue: 255/255), Color(red: 233/255, green: 241/255, blue: 255/255), Color(red: 247/255, green: 229/255, blue: 255/255), Color(red: 252/255, green: 233/255, blue: 239/255), Color(red: 255/255, green: 241/255, blue: 235/255), Color(red: 255/255, green: 245/255, blue: 233/255), Color(red: 254/255, green: 253/255, blue: 238/255), Color(red: 239/255, green: 247/255, blue: 233/255)]
    
    var body: some View {
        let i = subjectExp.firstIndex(where: { $0.id == exposition.id }) ?? 0
        NavigationLink(destination: RecordPage(recordingManager: exposition.recordingManager, expositions: $expositions, exposition: $exposition, refreshID: $refreshID)) {
            ExpositionStyleSpecialSubject(exposition: $exposition, expositions: $expositions, sections: $sections)
        }
        .listRowBackground(ExpositionRowTrash.backgroundColor[i % ExpositionRowTrash.backgroundColor.count])
        .swipeActions {
            Button(action: {
                exposition.recordingManager.deleteRecordedAudio()
                exposition.recordingManager.deleteDocument()
                expositions[exposition.secCode]?.removeAll(where: {$0.id == exposition.id})
                Exposition.saveDictionary(expositions: expositions)
                refreshID = UUID()
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
            .tint(.red)
            Button(action: {
                exposition.trash = false
                exposition.trashDate = nil
                Exposition.saveDictionary(expositions: expositions)
                refreshID = UUID()
            }) {
                Text("Restore")
                Image(systemName: "arrow.uturn.backward")
            }
            .tint(.blue)
        }
        
    }
}
