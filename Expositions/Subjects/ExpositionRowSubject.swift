//
//  ExpositionRowSubject.swift
//  Expositions
//
//  Created by Studente on 20/07/24.
//

import SwiftUI

struct ExpositionRowSubject: View {
    @Binding var expositions: [Int:[Exposition]]
    @Binding var section: Section
    @Binding var sections: [Section]
    @State var exposition: Exposition
    var subjectExp: [Exposition]
    
    @Binding var showCreateExpView: Bool
    @State private var showContextMenu = false
    @State private var showSectionList = false
    @State private var showRenameAlert = false
    
    @State var text = ""
    
    static let backgroundColor = [Color(red: 229/255, green: 247/255, blue: 255/255), Color(red: 233/255, green: 241/255, blue: 255/255), Color(red: 247/255, green: 229/255, blue: 255/255), Color(red: 252/255, green: 233/255, blue: 239/255), Color(red: 255/255, green: 241/255, blue: 235/255), Color(red: 255/255, green: 245/255, blue: 233/255), Color(red: 254/255, green: 253/255, blue: 238/255), Color(red: 239/255, green: 247/255, blue: 233/255)]
    
    var body: some View {
        let i = subjectExp.firstIndex(where: { $0.id == exposition.id }) ?? 0
        NavigationLink(destination: RecordPage(recordingManager: exposition.recordingManager, expositions: $expositions)) {
            if section.secCode != 0 && section.secCode != 1 && section.secCode != 2 {
                ExpositionStyleSubject(exposition: $exposition)
            } else {
                ExpositionStyleSpecialSubject(exposition: $exposition, expositions: $expositions, sections: $sections)
            }
        }
        .listRowBackground(ExpositionRowSubject.backgroundColor[i % ExpositionRowSubject.backgroundColor.count])
        .contextMenu {
            renameButton()
            moveButton()
            deleteButton(exposition: exposition)
        }
        .sheet(isPresented: $showSectionList) {
            SectionListView(sections: $sections, sourceSection: exposition.secCode, exposition: $exposition, expositions: $expositions)
        }
        .alert("Rename exposition", isPresented: $showRenameAlert) {
            Button("Cancel", role: .cancel) { text = "" }
            Button("Confirm", action: {
                if text != "" {
                    if let index = expositions[exposition.secCode]?.firstIndex(where: { $0.id == exposition.id }) {
                        expositions[exposition.secCode]?[index].recordingManager.recordName = text
                        Exposition.saveDictionary(expositions: expositions)
                    }
                }
                text = ""
            })
            TextField("Insert new name...", text: $text)
        }
    }
    
    func renameButton() -> some View {
        Button(action: {
            showRenameAlert.toggle()
        }) {
            HStack {
                Image(systemName: "pencil")
                Text("Rename")
            }
        }
    }
    
    func deleteButton(exposition: Exposition) -> some View {
        Button(action: {
            let item = exposition
            item.trash = true
            item.trashDate = Date.now
            expositions[2]?.append(item)
            expositions[exposition.secCode]?.removeAll(where: { $0.id == exposition.id })
            Exposition.saveDictionary(expositions: expositions)
        }) {
            HStack {
                Image(systemName: "trash.fill")
                Text("Delete")
            }
        }
    }
    
    func moveButton() -> some View {
        Button(action: {
            showSectionList.toggle()
        }) {
            HStack {
                Image(systemName: "folder.fill")
                Text("Move")
            }
        }
    }
}
