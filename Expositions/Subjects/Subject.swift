//
//  Subject.swift
//  Expositions1
//
//  Created by Studente on 09/07/24.
//

import SwiftUI

struct Subject: View {
    
    @Binding var section: Section
    @Binding var sections: [Section]
    
    @Binding var expositions: [Int:[Exposition]]
    
    @State private var showCreateExpView = false
    
    @State var showDeleteAlert = false
    @State var showRestoreAlert = false
    
    @State var text = ""
    @State private var searchText = ""
    
    private func subjectExp() -> [Exposition] {
        if section.secCode == 0 {
            return expositions.flatMap {$0.value}.filter{!$0.trash}
        } else if section.secCode == 1 {
            return expositions.flatMap{$0.value}.filter{($0.favorite && !$0.trash)}
        } else if section.secCode == 2 {
            return expositions.flatMap{$0.value}.filter{$0.trash}
        }
        return expositions[section.secCode] ?? []
    }
    
    var body: some View {
        if section.secCode != 2 {
            NavigationStack {
                List {
                    ForEach(subjectExp(), id: \.id) { exposition in
                        if searchText.isEmpty || exposition.recordingManager.recordName.lowercased().starts(with: searchText.lowercased()) {
                            ExpositionRowSubject(expositions: $expositions, section: $section, sections: $sections, exposition: exposition, subjectExp: subjectExp(), showCreateExpView: $showCreateExpView)
                                .swipeActions {
                                    Button(action: {
                                        let item = exposition
                                        item.trash = true
                                        item.trashDate = Date.now
                                        expositions[2]?.append(item)
                                        expositions[item.secCode]?.removeAll(where: {$0.id == item.id})
                                        Exposition.saveDictionary(expositions: expositions)
                                    }) {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                    if !exposition.favorite {
                                        Button(action: {
                                            let item = exposition
                                            item.favorite = true
                                            updateExposition(item)
                                        }) {
                                            Text("Favorite")
                                            Image(systemName: "heart")
                                        }
                                        .tint(.orange)
                                    } else {
                                        Button(action: {
                                            let item = exposition
                                            item.favorite = false
                                            updateExposition(item)
                                        }) {
                                            Text("Unfavorite")
                                            Image(systemName: "heart.slash")
                                        }
                                        .tint(.orange)
                                    }
                                }
                        }
                    }
                }
                .navigationTitle(LocalizedStringKey(section.name))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showCreateExpView.toggle()
                        }) {
                            Image(systemName: "plus.app")
                                .imageScale(.large)
                        }
                        .padding()
                        .alert("Create new exposition", isPresented: $showCreateExpView) {
                            Button("Cancel", role: .cancel) { text = "" }
                            Button("Confirm", action: {
                                if text != "" {
                                    let recordingManager = RecordingManager()
                                    recordingManager.recordName = text
                                    expositions[section.secCode]?.append(Exposition(date: Date.now, recordingManager: recordingManager, secCode: section.secCode))
                                    Exposition.saveDictionary(expositions: expositions)
                                }
                                text = ""
                            })
                            TextField("Insert name...", text: $text)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
        } else {
            NavigationStack {
                List {
                    ForEach(subjectExp(), id: \.id) { exposition in
                        if searchText.isEmpty || exposition.recordingManager.recordName.lowercased().starts(with: searchText.lowercased()) {
                            ExpositionRowTrash(expositions: $expositions, section: $section, sections: $sections, exposition: exposition, subjectExp: subjectExp())
                        }
                    }
                }
                .navigationTitle(LocalizedStringKey(section.name))
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            showDeleteAlert.toggle()
                        }) {
                            Text("Delete all")
                                .imageScale(.large)
                        }
                        .padding()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            showRestoreAlert.toggle()
                        }) {
                            Text("Restore all")
                                .imageScale(.large)
                        }
                        .padding()
                    }
                }
                .alert("All expositions will be permanently deleted. Do you want to continue?", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Confirm", action: {
                        for exposition in subjectExp() {
                            expositions[2]?.removeAll(where: { $0.id == exposition.id })
                            Exposition.saveDictionary(expositions: expositions)
                        }
                    })
                }
                .alert("All expositions will be restored. Do you want to continue?", isPresented: $showRestoreAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Confirm", action: {
                        for exposition in subjectExp() {
                            let item = exposition
                            item.trash = false
                            item.trashDate = nil
                            expositions[item.secCode]?.append(item)
                            expositions[2]?.removeAll(where: { $0.id == exposition.id })
                            Exposition.saveDictionary(expositions: expositions)
                        }
                    })
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
        }
    }
    
    private func updateExposition(_ item: Exposition) {
        if let index = expositions[item.secCode]?.firstIndex(where: { $0.id == item.id }) {
            expositions[item.secCode]?[index] = item
            Exposition.saveDictionary(expositions: expositions)
        }
    }
}

#Preview {
    Subject(section: .constant(Section(name: "All expositions", symbol: "folder.fill", color: Color(red: 0.3568627450980392, green: 0.6627450980392157, blue: 0.9568627450980393), specialCode: 0)),sections: .constant([Section(name: "All expositions", symbol: "folder.fill", color: Color(red: 0.3568627450980392, green: 0.6627450980392157, blue: 0.9568627450980393), specialCode: 0), Section(name: "Favorites", symbol: "heart.fill", color: Color(red: 1, green: 0.27058823529411763, blue: 0.2235294117647059), specialCode: 1),Section(name: "Trash", symbol: "trash.fill", color: Color(red: 0.6784313725490196, green: 0.6784313725490196, blue: 0.6784313725490196), specialCode: 2)]), expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "8", secCode: 3)]]))
}
