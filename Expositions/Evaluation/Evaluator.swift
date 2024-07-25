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
    var cancellationToken: AnyCancellable?
    var operationQueue = OperationQueue()
    
    @Published var progress: Float = -1
    @Published var completed: Bool = false
    
    var documentText: String?
    var workItems: [DispatchWorkItem] = []

    init(exposition: Binding<Exposition>, expositions: Binding<[Int : [Exposition]]>, evaluationError: Binding<Bool>) {
        self._exposition = exposition
        self._expositions = expositions
        self._evaluationError = evaluationError
    }
    
    func evaluate() {
        self.progress = 0

        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1

        let operation = BlockOperation { [weak self] in
            DispatchQueue.main.async {
                self?.documentText = DocumentManager.extractTextFromPDF(fileName: (self?.exposition.recordingManager.docFilename)!)
                if let text = self?.documentText {
                    self?.exposition.documentText = text
                    self?.exposition.recordingManager.requestTranscribePermissions()

                    self?.exposition.recordingManager.processAudioFile(fileName: (self?.exposition.recordingManager.recordFilename)!, evaluator: self!) { success in
                        if success {
                            self?.taskCompleted()
                        } else {
                            self?.evaluationError.toggle()
                            return
                        }
                    }
                } else {
                    self?.evaluationError.toggle()
                    return
                }
            }
        }

        operationQueue.addOperation(operation)
    }

    func stopTask() {
        operationQueue.cancelAllOperations()
        for workItem in workItems {
            workItem.cancel()
        }
        workItems.removeAll()
        exposition.recordingManager.transcription = ""
        exposition.evaluated = false
        self.progress = -1
    }
    
    func taskCompleted() {
        DispatchQueue.main.async { [self] in
            exposition.evaluated = true
            self.completed = true
            Exposition.saveDictionary(expositions: expositions)
        }
    }

    func addWorkItem(_ workItem: DispatchWorkItem) {
        self.workItems.append(workItem)
    }
}
