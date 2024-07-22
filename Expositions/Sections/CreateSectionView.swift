//
//  ModalAdd.swift
//  Expositions1
//
//  Created by Studente on 12/07/24.
//

import SwiftUI
import PhotosUI

struct CreateSectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var sections: [Section]
    @Binding var expositions: [Int:[Exposition]]
    
    @State private var sectionName: String = ""
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showPicker = false
    
    @State private var showCreateIconView = false
    @State var color: Color
    @State var symbol: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Create new section")
                    .font(.system(size: 30))
                    .bold()
                    .padding([.top,.leading])
                    .bold()
                Spacer()
            }
            HStack {
                if let image = selectedImage {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .cornerRadius(10)
                        Menu("Change icon") {
                            Button(action: {
                                self.showPicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "photo.badge.plus")
                                }
                                Text("Insert image")
                            }
                            
                            Button(action: {
                                selectedImage = nil
                                self.showCreateIconView.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "paintpalette")
                                }
                                Text("Create icon")
                            }
                        }.foregroundColor(Color(red:0.3568627450980392,green:0.6627450980392157,blue:0.9568627450980393))
                    }
                } else {
                    if symbol == "" {
                        ZStack(alignment: .center) {
                            Circle()
                                .frame(width: 120, height: 120)
                                .foregroundColor(color)
                            Menu("Create icon") {
                                Button(action: {
                                    self.showPicker.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "photo.badge.plus")
                                    }
                                    Text("Insert image")
                                }
                                
                                Button(action: {
                                    selectedImage = nil
                                    self.showCreateIconView.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "paintpalette")
                                    }
                                    Text("Create icon")
                                }
                            }.foregroundColor(Color(red:0.3568627450980392,green:0.6627450980392157,blue:0.9568627450980393))
                        }
                    } else {
                        VStack {
                            ZStack(alignment: .center) {
                                Circle()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(color)
                                Image(systemName: symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            Menu("Change icon") {
                                Button(action: {
                                    self.showPicker.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "photo.badge.plus")
                                    }
                                    Text("Insert image")
                                }
                                
                                Button(action: {
                                    self.showCreateIconView.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "paintpalette")
                                    }
                                    Text("Create icon")
                                }
                            }.foregroundColor(Color(red:0.3568627450980392,green:0.6627450980392157,blue:0.9568627450980393))
                        }
                    }
                }
                TextField("Insert section name...", text: $sectionName)
                    .padding()
            }.padding()
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images).onChange(of: selectedItem) {
            Task {
                if let loaded = try? await selectedItem?.loadTransferable(type: Data.self) {
                    selectedImage = UIImage(data: loaded)
                } else {
                    // gestire l'errore
                }
            }
        }
        .sheet(isPresented: $showCreateIconView) {
            CreateIconView(selectedSymbol: $symbol, selectedColor: $color)
        }
        Button(action: {
            var section: Section? = nil
            if let image = selectedImage {
                section = Section(name: sectionName, image: image, symbol: nil, color: nil)
            } else if symbol != "" {
                section = Section(name: sectionName, image: nil, symbol: symbol, color: color)
            } else {
                section = Section(name: sectionName, image: nil, symbol: nil, color: color)
            }
            if let section = section {
                sections.append(section)
                Section.save(sections: sections)
                expositions[section.secCode] = []
                Exposition.saveDictionary(expositions: expositions)
            }
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .disabled(sectionName == "")
        .opacity(sectionName == "" ? 0.5 : 1)
    }
}

#Preview {
    CreateSectionView(sections: .constant([Section(name: "Science", image: nil, symbol: "atom", color: Color(red: 0.6941176470588235, green: 0.8666666666666667, blue: 0.5450980392156862)),Section(name: "History", image: nil, symbol: "fossil.shell.fill", color: Color(red: 0.996078431372549, green: 0.7058823529411765, blue: 0.24705882352941178)),Section(name: "Literature", image: UIImage(contentsOfFile: "shakespeare"), symbol: nil, color: nil)]), expositions: .constant([:]), color: Color(red: 0.8274509803921568, green: 0.8274509803921568, blue: 0.8274509803921568), symbol: "book.fill")
}
