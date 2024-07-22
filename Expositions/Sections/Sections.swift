//
//  Sections.swift
//  Expositions1
//
//  Created by Studente on 05/07/24.
//

import SwiftUI
import PhotosUI

struct Sections: View {
    @Binding var sections: [Section]
    @Binding var expositions: [Int:[Exposition]]
    
    @State private var searchText = ""
    
    @State private var showNewWindow = false
    @State private var showIconView = false
    @State private var showAlertIcon = false
    @State private var showRenameWindow = false
    @State private var showPhotosPicker = false
    @State private var showPhotoAlert = false
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var text: String = ""
    @State private var selectedSectionIndex: Int = -1
    
    var body: some View {
        NavigationStack {
            List {
                SwiftUI.Section(header: Text("General sections")) {
                    ForEach($sections.filter { $0.secCode.wrappedValue == 0 || $0.secCode.wrappedValue == 1 || $0.secCode.wrappedValue == 2 }) { $section in
                        if searchText.isEmpty || section.name.lowercased().starts(with: searchText.lowercased()) {
                            NavigationLink(destination: Subject(section: $section, sections: $sections, expositions: $expositions)) {
                                SectionRow(section: $section)
                            }
                        }
                    }
                }
                SwiftUI.Section(header: Text("Your sections")) {
                    ForEach($sections.filter { $0.secCode.wrappedValue > 2 }) { $section in
                        if searchText.isEmpty || section.name.lowercased().starts(with: searchText.lowercased()) {
                            NavigationLink(destination: Subject(section: $section, sections: $sections, expositions: $expositions)) {
                                SectionRow(section: $section)
                                    .swipeActions {
                                        Button(action: {
                                            if let index = sections.firstIndex(where: { $0.id == section.id }) {
                                                deleteSection(at: IndexSet(integer: index))
                                            }
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                            .contextMenu {
                                renameButton(section: section)
                                changeIconButton(section: section)
                                changeImageButton(section: section)
                                deleteButton(section: section)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sections")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.showNewWindow = true
                    }) {
                        NewButton()
                    }
                    .sheet(isPresented: self.$showNewWindow) {
                        CreateSectionView(sections: $sections, expositions: $expositions, color: Color.gray.opacity(0.8), symbol: "")
                            .presentationDetents([.medium, .large])
                            .presentationCompactAdaptation(.none)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .sheet(isPresented: $showIconView) {
            IconEditor(sectionIndex: $selectedSectionIndex, sections: $sections)
        }
        .alert("Impossible to edit", isPresented: $showAlertIcon) {
            Button("Ok", role: .cancel) {}
        }
        .alert(
            Text("Rename section"),
            isPresented: $showRenameWindow
        ) {
            Button("Cancel", role: .cancel) {text = ""}
            Button("Confirm", action: {
                if text != "" {
                    renameSection()
                }
            })
            TextField("Insert new name...", text: $text)
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images).onChange(of: selectedItem) {
            Task {
                if let loaded = try? await selectedItem?.loadTransferable(type: Data.self) {
                    selectedImage = UIImage(data: loaded)
                    if let image = selectedImage {
                        changeImage(image: image)
                    }
                } else {
                    showPhotoAlert.toggle()
                }
            }
        }
        .alert("Photo selection failed. Try again.", isPresented: $showPhotoAlert) {
            Button("Ok", role: .cancel) {}
        }
    }
    
    func deleteSection(at offsets: IndexSet) {
        sections.remove(atOffsets: offsets)
        Section.save(sections: sections)
    }
    
    func deleteSection(section: Section) {
        if let index = sections.firstIndex(where: { $0.id == section.id }) {
            sections.remove(at: index)
            Section.save(sections: sections)
        }
    }
    
    func renameSection() {
        sections[selectedSectionIndex].changeName(name: text)
        Section.save(sections: sections)
        text = ""
    }
        
    func changeImage(image: UIImage) {
        sections[selectedSectionIndex].changeImage(image: image)
        Section.save(sections: sections)
    }
    
    // Funzioni per i pulsanti del menu contestuale
    func renameButton(section: Section) -> some View {
        Button(action: {
            setSelectedSectionIndex(section: section)
            if selectedSectionIndex == -1 {
                showAlertIcon.toggle()
            } else {
                showRenameWindow.toggle()
            }
        }) {
            HStack {
                Image(systemName: "pencil")
                Text("Rename")
            }
        }
    }
    
    func changeIconButton(section: Section) -> some View {
        Button(action: {
            setSelectedSectionIndex(section: section)
            if selectedSectionIndex == -1 {
                showAlertIcon.toggle()
            } else {
                showIconView.toggle()
            }
        }) {
            HStack {
                Image(systemName: "paintpalette")
                Text("Change icon")
            }
        }
    }
    
    func changeImageButton(section: Section) -> some View {
        Button(action: {
            setSelectedSectionIndex(section: section)
            if selectedSectionIndex == -1 {
                showAlertIcon.toggle()
            } else {
                showPhotosPicker.toggle()
            }
        }) {
            HStack {
                Image(systemName: "photo")
                Text("Change image")
            }
        }
    }
    
    func deleteButton(section: Section) -> some View {
        Button(action: { deleteSection(section: section) }) {
            HStack {
                Image(systemName: "trash.fill")
                Text("Delete")
            }
        }
    }
    
    // Funzione per impostare l'indice della sezione selezionata
    func setSelectedSectionIndex(section: Section) {
        if let index = sections.firstIndex(where: {$0.id == section.id}) {
            selectedSectionIndex = index
        }
    }
}

struct SectionRow: View {
    @Binding var section: Section
    
    var body: some View {
        HStack {
            if let icon = section.icon {
                if let image = icon.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .cornerRadius(10)
                    Text(section.name)
                        .padding()
                } else {
                    ZStack(alignment: .bottomLeading) {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(icon.color)
                        if let symbol = icon.symbol {
                            Image(systemName: symbol)
                                .imageScale(.large)
                                .frame(width: 30, height: 30)
                                .offset(CGSize(width: 10, height: -10))
                                .foregroundColor(.white)
                        }
                    }
                    Text(section.name)
                        .padding()
                }
            }
        }
    }
}

struct NewButton: View {
    var body: some View {
        ZStack {
            Rectangle()
                .size(CGSize(width: 75, height: 33))
                .padding(.trailing, 65)
                .foregroundColor(Color(red: 0.3568627451, green: 0.662745098, blue: 0.9568627451))
                .clipShape(RoundedRectangle(cornerRadius: 5))
            HStack {
                Image(systemName: "plus")
                    .imageScale(.medium)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .bold()
                Text("New")
                    .foregroundColor(.white)
                    .bold()
                    .offset(CGSize(width: -5, height: 0))
            }
        }
    }
}

#Preview {
    Sections(sections: .constant([Section(name: "Science", image: nil, symbol: "atom", color: Color(red: 0.6941176470588235, green: 0.8666666666666667, blue: 0.5450980392156862)),Section(name: "History", image: nil, symbol: "fossil.shell.fill", color: Color(red: 0.996078431372549, green: 0.7058823529411765, blue: 0.24705882352941178)),Section(name: "Literature", image: UIImage(named: "shakespeare"), symbol: nil, color: nil)]),expositions: .constant([3:[Exposition(date: "03-12-2024", grade: "10",secCode:3)]]))
}

