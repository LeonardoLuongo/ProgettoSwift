//
//  Evaluator.swift
//  Expositions
//
//  Created by Studente on 22/07/24.
//

import SwiftUI

class Evaluator {
    @Binding var exposition: Exposition
    @Binding var expositions: [Int:[Exposition]]
    var audioPath: URL
    var transcription: String
    var docPath: URL
    
    @Binding var evaluationError: Bool
    
    var documentText: String?
    
    init(exposition: Binding<Exposition>, expositions: Binding<[Int : [Exposition]]>, evaluationError: Binding<Bool>) {
        self._exposition = exposition
        self._expositions = expositions
        self.audioPath = exposition.recordingManager.audioPath.wrappedValue!
        self.transcription = exposition.recordingManager.transcription.wrappedValue
        self.docPath = exposition.recordingManager.docPath.wrappedValue!
        self._evaluationError = evaluationError
    }
    
    func evaluate() {
        documentText = DocumentManager.extractTextFromPDF(url: docPath)
        if let text = documentText {
            
            print(text)
            
            // GEMINI CALL: elaborate transcription (punctuation, correction, etc.)
            
            // GEMINI CALL: compare document text to transcription
            
            // Elaborate response from Gemini
            
            // Update exposition (grade, evaluated) and expositions
            
            // Result view with errors and grade
            
        } else {
            evaluationError.toggle()
            print("Errore")
        }
    }
    
}
