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
    @Published var evaluating: Bool = false
    
    var documentText: String?
    var workItems: [DispatchWorkItem] = []
    
    private var evaluatedSpeech: EvaluatedSpeech?
    
    private var timers: [DispatchSourceTimer] = []

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
                self?.documentText = DocumentManager.extractTextFromPDF(docPath: self!.exposition.recordingManager.docPath!.absoluteString)
                if let text = self?.documentText{
                    self?.exposition.recordingManager.requestTranscribePermissions()
                    
                    if text.isEmpty
                    {
                        self?.handleError(message: "Empty Document: Cannot extract any text from the document. The Evaluation process can continue anyway, but it'll use the LLM knownledge", killTheEvaluation: false)
                    }

                    self?.exposition.recordingManager.processAudioFile(audioPath: self!.exposition.recordingManager.audioPath!.absoluteString, evaluator: self!) { success in
                        if success {
                            Task { [weak self] in
                                do {
                                    
                                    self!.evaluating = true
                                    
                                    // turn transcription into RawSpeech
                                    let rawSpeech = try RawSpeech(textInSingleWords: SingleWord.textToSingleWordArray(text: self!.exposition.recordingManager.transcription))
                                    
                                    // turn RawSpeech into PunctualizedSpeech through Gemini call
                                    let punctualizedSpeech = try await PunctualizedSpeech(rawSpeech: rawSpeech, context: text)
                                    
                                    // turn PunctualizedSpeech into EvaluatedSpeech through Gemini call
                                    self!.evaluatedSpeech = try await EvaluatedSpeech(context: text, punctualizedText: punctualizedSpeech)
                                    
                                    self?.taskCompleted()
                                } catch let error as Exception{
                                    self?.handleError(message: "\(error.exceptionName): \(error.exceptionMessage)")
                                    return
                                }
                                catch{
                                    self?.handleError(message: "\(error)")
                                    return
                                }
                            }
                        } else {
                            return
                        }
                    }
                } else {
                    self?.handleError(message: "Empty Document: Cannot extract any text from the document. The Evaluation process can continue anyway, but it'll use the LLM knownledge", killTheEvaluation: false)
                    return
                }
            }
        }

        operationQueue.addOperation(operation)
    }
    
    func handleError(message: String, killTheEvaluation: Bool = true) {
        self.exposition.recordingManager.errorMessage = message
        self.exposition.recordingManager.showErrorAlert = true
        
        if killTheEvaluation{
            self.stopTask()
            self.evaluating = false
        }
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
            exposition.evaluatedSpeech = evaluatedSpeech
            exposition.insertFinalEvaluation()
            exposition.evaluated = true
            self.completed = true
            exposition.recordingManager.deleteDocument()
            Exposition.saveDictionary(expositions: expositions)
        }
    }

    func addWorkItem(_ workItem: DispatchWorkItem) {
        self.workItems.append(workItem)
    }
    
    func addTimer(_ timer: DispatchSourceTimer) {
        timers.append(timer)
    }

    func invalidateTimers() {
        timers.forEach { $0.cancel() }
        timers.removeAll()
    }
}
