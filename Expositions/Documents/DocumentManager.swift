//
//  DocumentManager.swift
//  Expositions
//
//  Created by Studente on 22/07/24.
//

import Foundation
import PDFKit

class DocumentManager {
    
    static func extractTextFromPDF(url: URL) -> String? {
        guard let pdfDocument = PDFDocument(url: url) else {
            return nil
        }
        return pdfDocument.string
    }
    
    /*
    static func extractTextFromDoc(url: URL) -> String? {
        do {
            let data = try Data(contentsOf: url)
            let file = try DocFile(data: data)
            return file.customXForm
        } catch {
            return nil
        }
    }
    
    static func extractTextFromPPT(url: URL) -> String? {
        do {
            let data = try Data(contentsOf: url)
            let file = try PptFile(data: data)
            return file.powerPointDocumentStream.presentationSlides[0].perSlideHFContainer.
        }
    }
    */
}
