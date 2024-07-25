//
//  Evaluator.swift
//  Expositions
//
//  Created by Studente on 22/07/24.
//

import SwiftUI
import Combine

class Evaluator: ObservableObject {
    @Binding var exposition: Exposition
    @Binding var expositions: [Int:[Exposition]]
    
    @Binding var evaluationError: Bool
    
    @Published var progress: Float = -1
    
    var documentText: String?
    
    init(exposition: Binding<Exposition>, expositions: Binding<[Int : [Exposition]]>, evaluationError: Binding<Bool>) {
        self._exposition = exposition
        self._expositions = expositions
        self._evaluationError = evaluationError
    }
    
    func evaluate() {
        // Reset progress
        self.progress = 0
        
        DispatchQueue.main.async { [self] in
            self.documentText = DocumentManager.extractTextFromPDF(fileName: self.exposition.recordingManager.docFilename)
            if let text = self.documentText {
                exposition.documentText = text
                exposition.recordingManager.requestTranscribePermissions()
                
                exposition.recordingManager.processAudioFile(fileName: exposition.recordingManager.recordFilename, evaluator: self) { success in
                    if success {
                        // GEMINI CALL: elaborate transcription (punctuation, correction, etc.)
                        // GEMINI CALL: compare document text to transcription
                        // Elaborate response from Gemini
                        // Update exposition (grade, evaluated) and expositions
                        // Result view with errors and grade
                        self.taskCompleted()
                    } else {
                        self.evaluationError.toggle()
                        return
                    }
                }
            } else {
                self.evaluationError.toggle()
                return
            }
        }
    }
    
    func taskCompleted() {
        DispatchQueue.main.async { [self] in
            exposition.evaluated = true
            Exposition.saveDictionary(expositions: expositions)
        }
    }
}
