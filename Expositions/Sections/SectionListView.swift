import SwiftUI

// This view is used when the user wants to move an exposition to another section
// It will show the list containing all the sections saved (except "Favorites" and "Trash")
struct SectionListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var destinationSection: Int?
    @Binding var sections: [Section]
    var sourceSection: Int
    @Binding var exposition: Exposition
    @Binding var expositions: [Int:[Exposition]]
    
    var body: some View {
        List {
            ForEach($sections, id: \.id) { $section in
                if section.secCode != 1 && section.secCode != 2 {
                    Button(action: {
                        destinationSection = section.secCode
                        if let destinationSection = destinationSection {
                            if let index = expositions[sourceSection]?.firstIndex(where: { $0.id == exposition.id }) {
                                exposition.secCode = destinationSection
                                expositions[sourceSection]?.remove(at: index)
                                expositions[destinationSection]?.append(exposition)
                                Exposition.saveDictionary(expositions: expositions)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
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
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(icon.color)
                                        if let symbol = icon.symbol {
                                            if symbol == "folder.fill" {
                                                Image(systemName: symbol)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.white)
                                            } else {
                                                Image(uiImage: UIImage(named: symbol)!)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                    }
                                    .frame(width: 50, height: 50)
                                    Text(LocalizedStringKey(section.name))
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
