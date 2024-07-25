//
//  TestFinalPage.swift
//  Expositions
//
//  Created by Studente on 24/07/24.
//

import SwiftUI

struct TestFinalPage: View {
    
    @Binding var exposition: Exposition
    
    var body: some View {
        VStack {
            Text("Document text:")
                .font(.title)
            ScrollView {
                Text(exposition.documentText!)
            }
            Text("Your exposition:")
                .font(.title)
            ScrollView {
                Text(exposition.recordingManager.transcription)
            }
        }
    }
}
