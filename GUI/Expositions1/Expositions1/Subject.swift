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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Subject(section: .constant(Section(name: "History", image: nil, symbol: "fossil.shell.fill", color: Color(red: 0.996078431372549, green: 0.7058823529411765, blue: 0.24705882352941178))), sections: .constant([Section(name: "History", image: nil, symbol: "fossil.shell.fill", color: Color(red: 0.996078431372549, green: 0.7058823529411765, blue: 0.24705882352941178))]))
}
