import SwiftUI
import PhotosUI

// This is the page that the user sees when they first open the app
struct Sections: View {
    
    // MAIN DATA STRUCTURES
    @Binding var sections: [Section]
    @Binding var expositions: [Int:[Exposition]]
    
    @State private var searchText = "" // to implement searchable elements
    
    // to control alerts
    @State private var showNewWindow = false
    @State private var showIconView = false
    @State private var showAlertIcon = false
    @State private var showRenameWindow = false
    @State private var showPhotosPicker = false
    @State private var showPhotoAlert = false
    @State private var showDeleteAlert = false
    
    @State private var selectedSection: Section? // "Change section" operation
    
    @State private var selectedItem: PhotosPickerItem? // "Upload photo" operation
    @State private var selectedImage: UIImage? // "Upload photo" operation
    
    @State private var text: String = "" // "Insert name" operation
    
    @State private var selectedSectionIndex: Int = -1 // "Delete section" operation
    
    var body: some View {
        NavigationStack {
            List {
                SwiftUI.Section(header: Text("General sections")) { // SPECIAL SECTIONS
                    // "All expositions", "Favorites", "Trash"
                    ForEach($sections.filter { $0.secCode.wrappedValue == 0 || $0.secCode.wrappedValue == 1 || $0.secCode.wrappedValue == 2 }) { $section in
                        if searchText.isEmpty || NSLocalizedString(section.name, comment: "").lowercased().starts(with: searchText.lowercased()) {
                            NavigationLink(destination: Subject(section: $section, sections: $sections, expositions: $expositions)) {
                                SectionSpecialRow(section: $section)
                            }
                        }
                    }
                }
                SwiftUI.Section(header: Text("Your sections")) { // USER-MADE SECTIONS
                    ForEach($sections.filter { $0.secCode.wrappedValue > 2 }) { $section in
                        if searchText.isEmpty || section.name.lowercased().starts(with: searchText.lowercased()) {
                            NavigationLink(destination: Subject(section: $section, sections: $sections, expositions: $expositions)) {
                                SectionRow(section: $section)
                                    .swipeActions { // defined only for user-made sections
                                        Button(action: {
                                            deleteSection(section: section)
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                            .contextMenu { // defined only for user-made sections
                                renameButton(section: section)
                                changeIconButton(section: section)
                                changeImageButton(section: section)
                                deleteButton(section: section)
                            }
                            .alert(
                                Text("Selected section is not empty. Are you sure to continue?"),
                                isPresented: $showDeleteAlert
                            ) {
                                Button("Cancel", role: .cancel) {}
                                Button("Delete", action: {
                                    if let section = selectedSection {
                                        // Move expositions to "Trash" section
                                        if var expositionsForSection = expositions[section.secCode] {
                                            for exposition in expositionsForSection {
                                                exposition.trash = true
                                                exposition.trashDate = Date.now
                                                exposition.secCode = 0
                                                expositions[0]?.append(exposition)
                                            }
                                            expositions.removeValue(forKey: section.secCode)
                                        }
                                        
                                        // Remove the section
                                        sections.remove(at: section.secCode)
                                        
                                        // Update secCodes in sections and expositions
                                        Section.updateSecCodes(sections: &sections, expositions: &expositions)
                                        
                                        // Save updated data
                                        Section.save(sections: sections)
                                        Exposition.saveDictionary(expositions: expositions)
                                    }
                                })

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
                    .sheet(isPresented: self.$showNewWindow) { // when "NewButton" is pressed
                        CreateSectionView(sections: $sections, expositions: $expositions, color: Color.gray.opacity(0.8), symbol: "")
                            .presentationDetents([.medium, .large])
                            .presentationCompactAdaptation(.none)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .sheet(isPresented: $showIconView) {
            IconEditor(sectionIndex: $selectedSectionIndex, sections: $sections) // When user wants to change the icon of a section and create a new custom one
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
    
    func deleteSection(section: Section) {
        if !expositions[section.secCode]!.isEmpty {
            selectedSection = section
            showDeleteAlert.toggle()
        } else if let index = sections.firstIndex(where: { $0.id == section.id }) {
            expositions.removeValue(forKey: section.secCode)
            sections.remove(at: index)
            Section.updateSecCodes(sections: &sections, expositions: &expositions)
            Section.save(sections: sections)
            Exposition.saveDictionary(expositions: expositions)
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
    
    // Functions for context menu buttons
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
    
    // Function to set the index of selected section
    func setSelectedSectionIndex(section: Section) {
        if let index = sections.firstIndex(where: {$0.id == section.id}) {
            selectedSectionIndex = index
        }
    }
}

// Single section row
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
                    ZStack(alignment: .center) {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(icon.color)
                        if let symbol = icon.symbol {
                            Image(uiImage: UIImage(named: symbol)!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    }
                    Text(section.name)
                        .padding()
                }
            }
        }
    }
}

// Rows for special sections ("All expositions", "Favorites" and "Trash")
struct SectionSpecialRow: View {
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
                    Text(LocalizedStringKey(section.name))
                        .padding()
                }
            }
        }
    }
}

struct NewButton: View {
    var body: some View {
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
        .background(Color(red: 0.3568627451, green: 0.662745098, blue: 0.9568627451))
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    Sections(sections: .constant([Section(name: "Science", image: nil, symbol: "SCIENZE NATURALI", color: Color(red: 0.6941176470588235, green: 0.8666666666666667, blue: 0.5450980392156862)),Section(name: "History", image: nil, symbol: "STORIA", color: Color(red: 0.996078431372549, green: 0.7058823529411765, blue: 0.24705882352941178))]),expositions: .constant([3:[Exposition(date: "03-12-2024", grade: "10",secCode:3)]]))
}

