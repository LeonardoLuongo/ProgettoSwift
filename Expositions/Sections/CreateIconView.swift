//
//  CreateIconView.swift
//  Expositions1
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct CreateIconView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedSymbol: String
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Text("Create Icon")
                    .font(.system(size: 30))
                    .bold()
                    .padding([.top,.leading])
                    .bold()
                Spacer()
            }
            IconView(selectedSymbol: $selectedSymbol, selectedColor: $selectedColor)
        }
            
        Spacer()
        
        Button(action: {
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
    }
}

struct IconView: View {
    
    @Binding var selectedSymbol: String
    @Binding var selectedColor: Color
    
    let symbols = ["", "book.fill", "pencil", "deskclock.fill", "graduationcap.fill", "highlighter", "laptopcomputer", "mic.fill", "paperclip", "paperplane.fill", "person.3.fill", "rectangle.stack.fill", "scribble", "square.and.pencil", "text.book.closed.fill", "trash.fill", "wrench.and.screwdriver.fill", "books.vertical.fill", "folder.fill", "globe", "headphones", "house.fill", "magnifyingglass", "map.fill", "newspaper.fill", "note.text", "pencil.and.outline", "person.fill.questionmark", "printer.fill", "questionmark.diamond.fill", "ruler.fill", "square.grid.2x2.fill", "tv.fill", "video.fill", "wifi", "xmark.bin.fill", "clock.fill", "doc.text.fill", "envelope.fill", "gear", "link", "lock.fill", "paintbrush.fill", "pencil.tip.crop.circle", "person.2.fill", "pin.fill", "plus.app.fill", "rectangle.and.pencil.and.ellipsis", "square.and.arrow.up.fill", "text.insert", "trash.slash.fill", "atom", "flame.fill", "leaf.arrow.triangle.circlepath", "lightbulb.fill", "moon.stars.fill", "pencil.tip", "scroll.fill", "shield.lefthalf.fill", "staroflife.fill", "thermometer.sun.fill", "timer", "tortoise.fill", "tray.full.fill", "wind", "wrench.fill", "globe.asia.australia.fill", "map", "paperplane.circle.fill", "pencil.and.ellipsis.rectangle", "person.2.square.stack.fill", "pin.circle.fill", "square.and.arrow.down.fill", "text.bubble.fill", "trash.circle.fill"];


    private let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        Text("Your icon:")
        if selectedSymbol == "" {
            Image(systemName: "book.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding()
                .foregroundColor(.white)
                .background(selectedColor)
                .cornerRadius(10)
        } else {
            Image(systemName: selectedSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding()
                .foregroundColor(.white)
                .background(selectedColor)
                .cornerRadius(10)
        }
        
        ColorPicker("Select Background Color", selection: $selectedColor)
            .padding()
            .font(.system(size: 20))
        
        HStack {
            Text("Select Symbol")
                .padding()
                .font(.system(size: 20))
            Spacer()
        }
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(symbols, id: \.self) { symbol in
                        Button(action: {
                            selectedSymbol = symbol
                        }) {
                            Image(systemName: symbol)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding()
                                .foregroundColor(.white)
                                .background(selectedColor)
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedSymbol = symbol
                                }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    CreateIconView(selectedSymbol: .constant("book.fill"), selectedColor: .constant(Color(red: 0.6784313725490196, green: 0.6784313725490196, blue: 0.6784313725490196)))
}
