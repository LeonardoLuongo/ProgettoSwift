//
//  IconView.swift
//  Expositions
//
//  Created by Studente on 21/07/24.
//

import SwiftUI

struct IconView: View {
    
    @Binding var selectedSymbol: String
    @Binding var selectedColor: Color
    
    let symbols = ["default", "book.fill", "pencil", "deskclock.fill", "graduationcap.fill", "highlighter", "laptopcomputer", "mic.fill", "paperclip", "paperplane.fill", "person.3.fill", "rectangle.stack.fill", "scribble", "square.and.pencil", "text.book.closed.fill", "trash.fill", "wrench.and.screwdriver.fill", "books.vertical.fill", "folder.fill", "globe", "headphones", "house.fill", "magnifyingglass", "map.fill", "newspaper.fill", "note.text", "pencil.and.outline", "person.fill.questionmark", "printer.fill", "questionmark.diamond.fill", "ruler.fill", "square.grid.2x2.fill", "tv.fill", "video.fill", "wifi", "xmark.bin.fill", "clock.fill", "doc.text.fill", "envelope.fill", "gear", "link", "lock.fill", "paintbrush.fill", "pencil.tip.crop.circle", "person.2.fill", "pin.fill", "plus.app.fill", "rectangle.and.pencil.and.ellipsis", "square.and.arrow.up.fill", "text.insert", "trash.slash.fill", "atom", "flame.fill", "leaf.arrow.triangle.circlepath", "lightbulb.fill", "moon.stars.fill", "pencil.tip", "scroll.fill", "shield.lefthalf.fill", "staroflife.fill", "thermometer.sun.fill", "timer", "tortoise.fill", "tray.full.fill", "wind", "wrench.fill", "globe.asia.australia.fill", "map", "paperplane.circle.fill", "pencil.and.ellipsis.rectangle", "person.2.square.stack.fill", "pin.circle.fill", "square.and.arrow.down.fill", "text.bubble.fill", "trash.circle.fill"];


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
        } else if selectedSymbol == "default" {
            Rectangle()
                .scaledToFit()
                .foregroundColor(selectedColor)
                .frame(width: 20, height: 20)
                .padding()
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

