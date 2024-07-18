//
//  IconEditor.swift
//  Expositions
//
//  Created by Studente on 17/07/24.
//

import SwiftUI

struct IconEditor: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var sectionIndex: Int
    @Binding var sections: [Section]
    @State var symbol: String = "book.fill"
    @State var color: Color = Color(red: 0.6784313725490196, green: 0.6784313725490196, blue: 0.6784313725490196)
    
    var body: some View {
        VStack {
            HStack {
                Text("Edit Icon")
                    .font(.system(size: 30))
                    .bold()
                    .padding([.top,.leading])
                    .bold()
                Spacer()
            }
            IconView(selectedSymbol: $symbol, selectedColor: $color)
            HStack {
                Button(action: {
                    sections[sectionIndex].changeIcon(color: color, symbol: symbol)
                    Section.save(sections: sections)
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
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear {
            if let icon = sections[sectionIndex].icon {
                if let color = icon.color {
                    self.color = color
                }
                if let symbol = icon.symbol {
                    self.symbol = symbol
                }
            }
        }
        .padding()
    }
}

#Preview {
    IconEditor(sectionIndex: .constant(0), sections: .constant([Section(name: "Science", image: nil, symbol: "atom", color: Color(red: 0.6941176470588235, green: 0.8666666666666667, blue: 0.5450980392156862))]))
}
