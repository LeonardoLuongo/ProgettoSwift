//
//  Sections.swift
//  Expositions1
//
//  Created by Studente on 05/07/24.
//

import SwiftUI

struct Sections: View {
    @State var sections: [Section]
    @State private var searchText = ""
    
    @State private var showNewWindow = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($sections, id: \.id) { $section in
                    if searchText.isEmpty || section.name.lowercased().starts(with: searchText.lowercased()) {
                        NavigationLink(destination: Subject(section: $section, sections: $sections)) {
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
                                            Image(systemName: icon.symbol!)
                                                .imageScale(.large)
                                                .frame(width: 30, height: 30)
                                                .offset(CGSize(width: 10, height: -10))
                                                .foregroundColor(.white)
                                        }
                                        Text(section.name)
                                            .padding()
                                    }
                                }
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
                    }){
                        ZStack {
                            Rectangle()
                                .size(CGSize(width: 75, height: 33))
                                .padding(.trailing, 65)
                                .foregroundColor(Color(red:0.3568627450980392,green:0.6627450980392157,blue:0.9568627450980393))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            HStack {
                                Image(systemName: "plus")
                                    .imageScale(.medium)
                                    .frame(width: 30, height: 30)
                                    .offset(CGSize(width: 0, height: 0))
                                    .foregroundColor(.white)
                                    .bold()
                                Text("New")
                                    .offset(CGSize(width: -6, height: 0))
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                    }.sheet(isPresented: self.$showNewWindow) {
                        ModalAdd(sections: $sections, color: Color(red: 0.8274509803921568, green: 0.8274509803921568, blue: 0.8274509803921568), symbol: "")
                            .presentationDetents([.medium,.large])
                            .presentationCompactAdaptation(.none)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

#Preview {
    Sections(sections: [Section(name: "Science", image: nil, symbol: "atom", color: Color(red: 0.6941176470588235, green: 0.8666666666666667, blue: 0.5450980392156862)),Section(name: "History", image: nil, symbol: "fossil.shell.fill", color: Color(red: 0.996078431372549, green: 0.7058823529411765, blue: 0.24705882352941178)),Section(name: "Literature", image: Image("shakespeare"), symbol: nil, color: nil)])
}

