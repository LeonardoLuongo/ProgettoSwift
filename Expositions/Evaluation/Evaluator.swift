//
//  Evaluator.swift
//  Expositions
//
//  Created by Studente on 22/07/24.
//

import SwiftUI

class Evaluator {
    var exposition: Exposition
    var expositions: [Int:[Exposition]]
    var audioPath: URL
    var transcription: String
    var docPath: URL
    
    @Binding var evaluationError: Bool
    
    var documentText: String?
    
    init(exposition: Exposition, expositions: [Int : [Exposition]], audioPath: URL, transcription: String, docPath: URL, evaluationError: Binding<Bool>) {
        self.exposition = exposition
        self.expositions = expositions
        self.audioPath = audioPath
        self.transcription = transcription
        self.docPath = docPath
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
        }
    }
    
}
